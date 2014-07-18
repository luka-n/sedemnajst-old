class Topic < ActiveRecord::Base
  include UpdatedAtTrigger
  include SyncLog

  belongs_to :user
  has_many :posts, dependent: :delete_all

  validates :title, presence: true
  validates :remote_id, presence: true, uniqueness: true

  trigger.after(:insert) do
    "UPDATE users SET topics_count = topics_count + 1 WHERE id = NEW.user_id"
  end

  trigger.after(:delete) do
    "UPDATE users SET topics_count = topics_count - 1 WHERE id = OLD.user_id"
  end

  trigger.after(:update) do
    <<-SQL
      IF NEW.user_id != OLD.user_id THEN
        UPDATE users SET topics_count = topics_count - 1 WHERE id = OLD.user_id;
        UPDATE users SET topics_count = topics_count + 1 WHERE id = NEW.user_id;
      END IF;
    SQL
  end

  scope :last_post_remote_created_on_gteq, -> date {
    where("last_post_remote_created_at >= ?", Time.parse(date))
  }
  scope :last_post_remote_created_on_lteq, -> date {
    where("last_post_remote_created_at <= ?", Time.parse(date).end_of_day)
  }

  class << self
    def ransackable_scopes(auth_object=nil)
      [:last_post_remote_created_on_gteq, :last_post_remote_created_on_lteq]
    end

    def sync_all
      sync_log.info "Starting sync"
      Mn3njalnik::Forum.find(17).topics.each do |remote|
        topic = find_by_remote_id(remote.id)
        unless topic
          user = User.find_or_create_by_remote_id!(remote.user_id)
          topic = Topic.create!(title: remote.title,
                                user_id: user.id,
                                remote_id: remote.id)
        end
        if topic.posts_count != remote.posts_count
          topic.sync(remote)
        end
      end
      sync_log.info "Ending sync"
    end
  end

  def sync(remote=nil)
    remote ||= Mn3njalnik::Topic.find(remote_id)
    # Verify last post we have is where it was in the remote topic
    # Otherwise just redo the entire topic for now
    if posts_count > 1
      last_local = posts.order(:remote_id).last
      last_remote = remote.posts(offset: posts_count - 1).first
      if !last_remote || last_local.remote_id != last_remote.id
        sync_log.info "Thrashing topic w/ remote_id #{remote_id} before sync, due to signs of tampering"
        posts.delete_all
        reload
      end
    end
    sync_log.info "Syncing topic w/ remote_id #{remote_id} and #{remote.posts_count - posts_count} new posts"
    remote.posts(offset: posts_count).each do |remote_post|
      user = User.find_or_create_by_remote_id!(remote_post.user_id)
      post = Post.create!(body: remote_post.body,
                          topic_id: id,
                          user_id: user.id,
                          remote_created_at: remote_post.created_at,
                          remote_id: remote_post.id)
    end
  end

  def to_s
    title
  end
end
