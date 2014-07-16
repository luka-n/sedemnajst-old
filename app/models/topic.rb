class Topic < ActiveRecord::Base
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
      sync_log = Logger.new(File.join(Rails.root, "log", "sync.log"))
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
          sync_log.info "Syncing topic w/ remote_id #{remote.id} and #{remote.posts_count - topic.posts_count} new posts"
          topic.sync(remote)
        end
      end
      sync_log.info "Ending sync"
    end
  end

  def sync(remote)
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
