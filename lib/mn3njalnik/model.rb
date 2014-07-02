module Mn3njalnik
  class Model < OpenStruct
    class << self
      def connection
        Mn3njalnik.connection
      end
    end

    def connection
      self.class.connection
    end
  end
end
