module ApplicationHelper

  def body_css(css_class = nil)
    @body_css ||= []
    if css_class.present?
      @body_css << css_class
    end

    @body_css.join(" ")
  end

end
