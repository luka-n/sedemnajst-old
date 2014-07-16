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

  # NOTE: only does accusative case
  def minutes_to_words(minutes)
    case minutes
    when 0 then "0 minut"
    when 1 then "1 minuto"
    when 2 then "2 minuti"
    when 3..4 then "#{minutes} minute"
    else "#{minutes} minut"
    end
  end

  def last_sync_at(nth=1)
    log_path = File.join(Rails.root, "log", "sync.log")
    return unless File.exists?(log_path)
    log = Elif.open(log_path)
    nth.times do
      ret = log.find { |l| l =~ /^I, \[(\S+) #\d+\]  INFO -- : Starting sync$/ }
      return unless ret
    end
    Time.parse($1)
  end

  def archive_status_text
    last = last_sync_at
    return unless last
    second_to_last = last_sync_at(2)
    return unless second_to_last
    last_n_minutes_ago = ((Time.now - last) / 60).to_i
    next_in_n_minutes = ((last - second_to_last) / 60).to_i - last_n_minutes_ago
    text = "zadnja posodobitev #{minutes_to_words(-last_n_minutes_ago)} nazaj"
    if next_in_n_minutes > 0
      text << ", naslednja predvidena čez #{minutes_to_words(next_in_n_minutes)}"
    elsif next_in_n_minutes == 0
      text << ", naslednja menda poteka prav zdaj"
    else
      text << ", naslednja pogrešana v akciji" <<
        " (zamuja že #{minutes_to_words(next_in_n_minutes.abs)})"
    end
  end
end
