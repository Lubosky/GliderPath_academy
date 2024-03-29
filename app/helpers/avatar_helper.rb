module AvatarHelper

  def user_avatar(resource, options = {})
    if resource.avatar.nil?
      content_tag(:div, nil, data: { layout_element: 'avatar', name: "#{resource.name}" }, class: "avatar-circle avatar-default bordered avatar-#{first_letter(resource)}")
    else
      content_tag(:img, nil, options)
    end
  end

  def first_letter(resource)
    resource.first_name.chr.downcase
  end

end
