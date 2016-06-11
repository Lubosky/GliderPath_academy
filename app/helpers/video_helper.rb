module VideoHelper
  def embed_video(resource)

    if resource.present?
      content_tag(:div, class: 'video-wrapper') do
        if resource.video_provider == 'Wistia'
          concat javascript_include_tag 'https://fast.wistia.com/assets/external/E-v1.js', async: true, charset: 'ISO-8859-1', 'data-turbolinks-track': false
          concat embed_wistia(resource.video_id)

        else resource.video_provider == 'Vimeo' || 'Youtube'
          content_tag :iframe, nil, src: "#{resource.video_embed_url}", frameborder: '0', allowfullscreen: true, mozallowfullscreen: true, webkitallowfullscreen: true, oallowfullscreen: true, msallowfullscreen: true

        end
      end
    end

  end

  def embed_wistia(resource)
    content_tag(:div, class: 'responsive-wrapper') do
      concat content_tag :div, nil, class: "wistia_embed wistia_async_#{resource}", videoFoam: true
    end
  end

end
