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

  def chart_filter(name)
    capture do
      form_tag "", class: "chart-filter" do
        concat radio_button_tag "#{name}_q", "all_time", false
        concat label_tag "#{name}_q_all_time", "vseskozi"
        concat radio_button_tag "#{name}_q", "last_year", false
        concat label_tag "#{name}_q_last_year", "zadnje leto"
        concat radio_button_tag "#{name}_q", "last_month", true
        concat label_tag "#{name}_q_last_month", "zadnji mesec"
        concat radio_button_tag "#{name}_q", "last_week", false
        concat label_tag "#{name}_q_last_week", "zadnji teden"
      end
    end
  end
end
