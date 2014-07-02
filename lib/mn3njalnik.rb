module Mn3njalnik
  BASE_U = "http://www.joker.si/mn3njalnik"

  class << self
    attr_accessor :connection
  end
end

require_relative "mn3njalnik/connection"
require_relative "mn3njalnik/model"
require_relative "mn3njalnik/user"
require_relative "mn3njalnik/forum"
require_relative "mn3njalnik/topic"
require_relative "mn3njalnik/post"
