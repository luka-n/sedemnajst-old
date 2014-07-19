# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  include UpdatedAtTrigger

  has_secure_password validations: false

  attr_accessor :avatar_url, :password_required

  has_many :topics, dependent: :destroy
  has_many :posts, dependent: :destroy

  has_many :user_posts_by_hour
  has_many :user_posts_by_dow
  has_many :user_posts_by_hod

  has_attached_file :avatar, styles: {small: "48x48", medium: "72x72"},
    url: "/avatars/:id/:style/:filename"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :remote_id, presence: true, uniqueness: true
  validates :password_request_token, uniqueness: true, allow_blank: true
  validates :password, confirmation: true, length: 6..255,
    if: -> { password.present? || password_required }

  before_create :fetch_avatar

  class << self
    def find_or_create_by_remote_id!(remote_id)
      remote = nil
      find_or_create_by!(remote_id: remote_id) do |user|
        remote = Mn3njalnik::User.find(remote_id)
        user.name = remote.name
        user.avatar_url = remote.avatar_url
      end
    rescue ActiveRecord::RecordInvalid => e
      if e.record.errors.added? :remote_id, :taken then retry
      elsif e.record.errors.added? :name, :taken
        usr = User.find_by_name(remote.name)
        usr.update_attributes(remote_id: remote.id)
        usr
      else raise e end
    end

    def find_by_password_request_token(token)
      where("password_request_token IS NOT NULL").
        where(password_request_token: token).
        first
    end

    def find_by_case_insensitive_name(name)
      where("lower(name) = ?", name.downcase).first
    end
  end

  def merge(source)
    source.posts.update_all user_id: id
    source.topics.update_all user_id: id
    source.destroy
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

  def send_password_request
    update_attributes!(password_request_token: SecureRandom.urlsafe_base64,
                       password_requested_at: Time.now)
    body = <<-END
      ov,

      svoje novo geslo lahko nastaviš tukaj:

      http://#{CONFIG[:host]}/user/password/edit?token=#{password_request_token}

      safe
    END
    Mn3njalnik.with_connection(CONFIG[:mn3njalnik][:sender][:username],
                               CONFIG[:mn3njalnik][:sender][:password]) do
      Mn3njalnik::User.find(remote_id).
        pm(subject: "geslo za vas, gospod ali gospodična #{name}",
           body: body)
    end
  rescue ActiveRecord::RecordInvalid => e
    if e.record.errors.added? :password_request_token, :taken then retry
    else raise e end
  end
end
