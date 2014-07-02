require "test_helper"

class Mn3njalnikTest < ActiveSupport::TestCase
  def setup
    Mn3njalnik.connection = Mn3njalnik::Connection.new
    Mn3njalnik.connection.login(CONFIG[:mn3njalnik][:username],
                                CONFIG[:mn3njalnik][:password])
  end
  
  test "parses the user page" do
    user = Mn3njalnik::User.find(461)
    assert_user_461 user
  end

  test "parses the topic page" do
    topic = Mn3njalnik::Topic.find(31567)
    assert_topic_31567 topic
  end

  test "parses the forum page" do
    topic = Mn3njalnik::Forum.find(17).topics.find { |t| t.id == 31567 }
    assert_topic_31567 topic
  end

  private

  def assert_user_461(user)
    assert_equal 461, user.id
    assert_equal "quattro", user.name
    assert_equal "http://www.joker.si/mn3njalnik/uploads/profile/photo-461.png",
      user.avatar_url
  end

  def assert_topic_31567(topic)
    assert_equal 31567, topic.id
    assert_equal "Svetovna ura.", topic.title
    assert_equal 461, topic.user_id
    assert_equal 1, topic.posts_count
    assert_equal DateTime.new(2014, 3, 5, 2, 40), topic.created_at
  end

  def assert_post_1773773(post)
    assert_equal 1773773, post.id
    assert_equal 31567, post.topic_id
    assert_equal "5/DVe4c9TxE72R/cbADpww==", Digest::MD5.base64digest(post.body)
    assert_equal 461, post.user_id
    assert_equal DateTime.new(2014, 3, 5, 0, 40, 59), post.created_at
  end
end
