module Mn3njalnik
  class Post < Model
    def topic
      self[:topic] ||= Topic.find(topic_id)
    end

    def user
      self[:user] ||= User.find(user_id)
    end
  end
end
