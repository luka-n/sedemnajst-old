class Topic < ActiveRecord::Base
  belongs_to :user
  has_many :posts

  validates :title, presence: true
  validates :remote_id, presence: true, uniqueness: true
  validates :remote_created_at, presence: true

  trigger.after(:insert) do
    "UPDATE users SET topics_count = topics_count + 1 WHERE id = NEW.user_id"
  end

  trigger.after(:delete) do
    "UPDATE users SET topics_count = topics_count - 1 WHERE id = OLD.user_id"
  end

  class << self
    def sync_all
      Mn3njalnik::Forum.find(17).topics.each do |remote|
        next if remote.posts_count > 128
        topic = find_by_remote_id(remote.id)
        unless topic
          user = User.find_or_create_by_remote_id!(remote.user_id)
          topic = Topic.create!(title: remote.title,
                                user_id: user.id,
                                remote_created_at: remote.created_at,
                                remote_id: remote.id)
        end
        if topic.posts_count != remote.posts_count
          topic.sync(remote)
        end
      end
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
