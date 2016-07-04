module AvatarHelper
  include LetterAvatar::AvatarHelper

  def user_avatar(resource, options = {})
    if resource.avatar.nil?
      image_tag letter_avatar_url(resource.first_name, 180), options
    else
      image_tag attachment_url(resource, :avatar, :fill, 180, 180), options
    end
  end
end
