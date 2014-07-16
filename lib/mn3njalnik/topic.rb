# -*- coding: utf-8 -*-
module Mn3njalnik
  class Topic < Model
    TOPIC_U = "#{BASE_U}/?showtopic=%d&st=%d"

    class << self
      def find(id)
        topic_from_page(connection.fetch(TOPIC_U % [id, 0]))
      end

      private

      def topic_from_page(page)
        topic = new
        topic.id = page.uri.query.match(/showtopic=(\d+)/)[1].to_i
        topic.title = page.search("h1.ipsType_pagetitle")[0].text.strip
        hovercard = page.search("h1.ipsType_pagetitle").search("../div/a")[0]
        topic.user_id = hovercard.attr("hovercard-id").to_i if hovercard
        topic.posts_count = page.search(".maintitle .ipsType_small").
          text.scan(/\d/).join.to_i + 1
        blob = page.search(".blend_links.desc.lighter")[0].
          text.strip.split(", ")[-1]
        topic
      end
    end

    def forum
      self[:forum] ||= Forum.find(forum_id)
    end

    def user
      self[:user] ||= User.find(user_id)
    end

    def posts(options={})
      Enumerator.new do |y|
        options[:offset] ||= 0
        start = options[:offset] % 40
        st = options[:offset] - start
        page = connection.fetch(TOPIC_U % [id, st])
        loop do
          page.search(".post_block")[start..-1].each do |row|
            y << post_from_row(row)
          end
          start = 0
          if (next_a = page.search("[rel='next']")[0])
            page = connection.fetch(next_a.attr("href"))
          else
            break
          end
        end
      end
    end

    private

    def post_from_row(row)
      post = Post.new
      post.topic_id = id
      post.body = row.search(".entry-content")[0].inner_html
      hovercard = row.search("[hovercard-id]")[0]
      post.user_id = hovercard.attr("hovercard-id").to_i if hovercard
      post.created_at = Time.parse(row.search(".published")[0].attr("title"))
      post.id = row.search(".report a")[0].attr("href").
        match(/pid=([0-9]+)/)[1].to_i
      post.topic = self
      post
    end
  end
end
