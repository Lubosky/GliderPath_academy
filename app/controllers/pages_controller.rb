class PagesController < ApplicationController
  layout 'page'

  def contact
    @contact_form = ContactForm.new
  end

  def faq
  end

  def home
    @courses = Course.published.ordered.includes(:instructor)
  end

  def privacy
  end

  def terms
  end

  def submit_contact_form
    begin
      @contact_form = ContactForm.new(params[:contact_form])
      @contact_form.request = request
      if @contact_form.deliver
        flash[:success] = t('flash.contact_form.success')
        redirect_to contact_path
      else
        flash[:error] = t('flash.contact_form.error')
        render :contact
      end
    rescue ScriptError
      flash[:error] = t('flash.contact_form.script_error')
      render :contact
    end
  end
end
