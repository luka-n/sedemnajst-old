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
end
