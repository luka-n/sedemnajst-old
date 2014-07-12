class User < ActiveRecord::Base
  attr_accessor :avatar_url

  has_many :topics, dependent: :destroy
  has_many :posts, dependent: :destroy

  has_many :user_posts_by_hour

  has_attached_file :avatar, styles: {small: "48x48", medium: "72x72"},
    url: "/avatars/:id/:style/:filename"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  validates :name, presence: true
  validates :remote_id, presence: true, uniqueness: true

  before_create :fetch_avatar

  class << self
    def find_or_create_by_remote_id!(remote_id)
      find_or_create_by!(remote_id: remote_id) do |user|
        remote = Mn3njalnik::User.find(remote_id)
        user.name = remote.name
        user.avatar_url = remote.avatar_url
      end
    rescue ActiveRecord::RecordInvalid => e
      if e.record.errors.added? :remote_id, :taken then retry
      else raise e end
    end
  end

  def to_s
    name
  end

  def fetch_avatar
    self.avatar = URI.parse(avatar_url) if avatar_url
  rescue OpenURI::HTTPError => e
    # Sometimes there is this inconsistency in our source material ...
    raise e unless e.message =~ /404/
  end

  def fetch_avatar!
    fetch_avatar && save!
  end
end
