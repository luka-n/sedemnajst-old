module Mn3njalnik
  class User < Model
    USER_U = "#{BASE_U}/?showuser=%d"
    PM_U = "#{BASE_U}/?app=members&module=messaging&section=send&do=form"

    class << self
      def find(id)
        user_from_page(connection.fetch(USER_U % id))
      end

      def user_from_page(page)
        user = new
        user.id = page.uri.query.match(/showuser=(\d+)/)[1].to_i
        user.name = page.search("h1 .nickname").text
        user.avatar_url = page.search("#profile_photo")[0].attr("src")
        user
      end
    end

    def pm(attributes)
      connection.fetch(PM_U) do |page|
        page.form_with(id: "msgForm") do |form|
          form["entered_name"] = name
          form["msg_title"] = attributes[:subject]
          form["Post"] = attributes[:body]
        end.submit
      end
    end
  end
end
