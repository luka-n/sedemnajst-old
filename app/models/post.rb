class Post < ActiveRecord::Base
  include UpdatedAtTrigger

  belongs_to :topic
  belongs_to :user

  validates :body, presence: true
  validates :topic_id, presence: true
  validates :remote_created_at, presence: true
  validates :remote_id, uniqueness: true
  validate :remote_id_present_post_legacy

  after_save ThinkingSphinx::RealTime.callback_for(:post)

  trigger.after(:insert) do
    <<-SQL
      UPDATE topics SET posts_count = posts_count + 1 WHERE id = NEW.topic_id;
      UPDATE topics SET last_post_remote_created_at = NEW.remote_created_at,
                        last_post_remote_id = NEW.remote_id
      WHERE id = NEW.topic_id;
      UPDATE users SET posts_count = posts_count + 1 WHERE id = NEW.user_id;
    SQL
  end

  trigger.after(:delete) do
    <<-SQL
      UPDATE users SET posts_count = posts_count - 1 WHERE id = OLD.user_id;
      UPDATE topics SET posts_count = posts_count - 1 WHERE id = OLD.topic_id;
      IF (OLD.remote_id IS NOT NULL AND OLD.remote_id =
          (SELECT last_post_remote_id FROM topics WHERE id = OLD.topic_id)) OR
           OLD.remote_created_at =
            (SELECT last_post_remote_created_at
             FROM topics WHERE id = OLD.topic_id) THEN
        UPDATE topics
        SET last_post_remote_created_at = last_posts.remote_created_at,
            last_post_remote_id = last_posts.remote_id
        FROM (
          SELECT max(remote_created_at) AS remote_created_at,
                 max(remote_id) AS remote_id
          FROM posts
          WHERE topic_id = OLD.topic_id
        ) AS last_posts
        WHERE id = OLD.topic_id;
      END IF;
    SQL
  end

  scope :remote_created_on_gteq, -> date {
    where("remote_created_at >= ?", Time.parse(date))
  }

  scope :remote_created_on_lteq, -> date {
    where("remote_created_at <= ?", Time.parse(date).end_of_day)
  }

  scope :remote_created_on_dow_eq, -> dow {
    where("date_part('isodow', remote_created_at) = ?", dow.to_i)
  }

  scope :remote_created_at_hod_eq, -> hod {
    where("date_part('hour', remote_created_at) = ?", hod.to_i)
  }

  class << self
    def ransackable_scopes(auth_object=nil)
      [:remote_created_on_gteq, :remote_created_on_lteq,
       :remote_created_on_dow_eq, :remote_created_at_hod_eq]
    end
  end

  private

  def remote_id_present_post_legacy
    if remote_created_at.utc > Time.utc(2013, 2, 3, 14, 12, 55) && !remote_id
      errors.add(:remote_id, "can't be blank")
    end
  end
end
