# -*- coding: utf-8 -*-
module Mn3njalnik
  class Forum < Model
    FORUM_U = "#{BASE_U}/?showforum=%d"

    class << self
      def find(id)
        new(id: id)
      end
    end

    def topics
      Enumerator.new do |y|
        page = connection.fetch(FORUM_U % id)
        loop do
          page.search(".__topic").each do |row|
            next if row.search("img[alt='Premaknjena tema']").any?
            y << topic_from_row(row)
          end
          if (next_a = page.search("[rel='next']")[0])
            page = connection.fetch(next_a.attr("href"))
          else
            break
          end
        end
      end
    end

    private

    def topic_from_row(row)
      topic = Topic.new
      topic.title = row.search(".topic_title")[0].text
      topic.id = row.attr("data-tid").to_i
      topic.posts_count = row.search(".col_f_views a")[0].text.
        scan(/\d/).join.to_i + 1
      hovercard = row.search(".col_f_content a[hovercard-id]")[0]
      topic.user_id = hovercard.attr("hovercard-id").to_i if hovercard
      blob = row.search(".topic_title")[0].attr("title")[21..-1]
      topic.created_at = if blob =~ /^danes, (\d{2}):(\d{2})$/
                           DateTime.now.change(hour: $1.to_i, min: $2.to_i)
                         elsif blob =~ /^včeraj, (\d{2}):(\d{2})$/
                           (DateTime.now - 1).
                             change(hour: $1.to_i, min: $2.to_i)
                         else
                           DateTime.parse(blob.gsub("avgust", "august").
                                          gsub(/([a-z]{3})[a-z]+/, "\\1"))
                         end
      topic.forum = self
      topic
    end
  end
end
