# -*- coding: utf-8 -*-
module ApplicationHelper
  def title
    if @title then "#@title - sedemnajst.si"
    else "sedemnajst.si" end
  end

  def avatar_img(user, size=:medium)
    image_tag user.avatar.url(size) if user && user.avatar?
  end

  def user_link(user)
    if user then link_to user, user_path(user)
    else link_to "neznanec", "#" end
  end

  def last_sync_at
    line = Elif.open(File.join(Rails.root, "log", "sync.log")).
      find { |l| l =~ /Starting sync/ }
    DateTime.parse(line.match(/\[(.+) .+\]/)[1])
  end

  def footer_text
    lsa = last_sync_at
    a = lsa
    b = DateTime.now
    diff = ((b - a) * 24 * 60).to_i
    n_minutes_ago = case diff
                    when 0 then "0 minut nazaj"
                    when 1 then "1 minuto nazaj"
                    when 2 then "2 minuti nazaj"
                    when 3..4 then "#{diff} minute nazaj"
                    else "#{diff} minut nazaj"
                    end
    if diff < 60
      in_n_minutes = case (n = 60 - diff)
                     when 1 then "čez 1 minuto"
                     when 2..4 then "čez #{n} minute"
                     else "čez #{n} minut"
                     end
    end
    content_tag(:p, "zadnja posodobitev na #{l(lsa, format: :short)} (#{n_minutes_ago})") <<
      (in_n_minutes ?
       content_tag(:p, "naslednja posodobitev je predvidena za #{in_n_minutes}") :
       content_tag(:p, "nova posodobitev menda poteka prav zdaj"))
  end
end
