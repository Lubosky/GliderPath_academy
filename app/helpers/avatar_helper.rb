module AvatarHelper
  def user_avatar(resource, options = {})
    if resource.avatar.nil?
      #TODO: image_tag resource.avatar_url, options
       image_tag '', options
    else
      image_tag attachment_url(resource, :avatar, :fill, 180, 180), options
    end
  end
end
