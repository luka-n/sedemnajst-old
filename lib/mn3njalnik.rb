module Mn3njalnik
  BASE_U = "http://www.joker.si/mn3njalnik"

  class << self
    attr_accessor :connection

    def with_connection(username, password, &block)
      old_connection = @connection
      @connection = Connection.new
      @connection.login username, password
      block.call
    ensure
      @connection = old_connection
    end
  end
end

require_relative "mn3njalnik/connection"
require_relative "mn3njalnik/model"
require_relative "mn3njalnik/user"
require_relative "mn3njalnik/forum"
require_relative "mn3njalnik/topic"
require_relative "mn3njalnik/post"
