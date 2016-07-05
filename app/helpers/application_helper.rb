module ApplicationHelper

  def body_css(css_class = nil)
    @body_css ||= []
    if css_class.present?
      @body_css << css_class
    end

    @body_css.join(" ")
  end

  def nav_path(link_text, link_path, http_method = nil)
    css_class = 'active' if
      current_page?(link_path)
    content_tag :li, class: css_class do
      link_to(link_text, link_path, http_method)
    end
  end

  def format_markdown(content)
    if content.present?
      pipeline_context = { gfm: true, link_attr: 'target="_blank"', skip_tags: [ 'pre', 'code' ] }
      pipeline = HTML::Pipeline.new [
        HTML::Pipeline::MarkdownFilter,
        HTML::Pipeline::SanitizationFilter,
        HTML::Pipeline::RougeFilter,
        HTML::Pipeline::TwemojiFilter,
        HTML::Pipeline::AutolinkFilter
      ], pipeline_context
      pipeline.call(content)[:output].to_s.html_safe
    else
      ''
    end
  end

end
