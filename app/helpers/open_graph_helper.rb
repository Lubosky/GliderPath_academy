module OpenGraphHelper
  def open_graph_tags
    raw [
      tag('meta', property: 'name', content: page_title),
      tag('meta', property: 'description', content: page_description),
      tag('meta', property: 'image', content: image_url('logo-default.png')),
      tag('meta', property: 'og:title', content: page_title),
      tag('meta', property: 'og:description', content: page_description),
      tag('meta', property: 'og:image', content: image_url('logo-default.png')),
      tag('meta', property: 'og:type', content: 'website'),
      tag('meta', property: 'og:url', content: url_for(only_path: false)),
      tag('meta', name: 'twitter:title', content: page_title),
      tag('meta', name: 'twitter:description', content: page_description),
      tag('meta', name: 'twitter:image', content: image_url('logo-default.png')),
      tag('meta', name: 'twitter:card', content: 'summary'),
      tag('meta', name: 'twitter:creator', content: Settings.social.twitter),
      tag('meta', name: 'twitter:site', content: Settings.social.twitter),
    ].join("\n")
  end

  private

    def image_url(filename)
      URI.join(root_url, image_path(filename))
    end

    def page_title
      content_for(:page_title) || title
    end

    def page_description
      content_for(:page_description) || t('meta.description')
    end
end
