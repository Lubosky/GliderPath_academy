class BaseMailer < ActionMailer::Base
  before_action :application_logo

  add_template_helper EmojiHelper

  layout 'application'
  default template_path: Proc.new { self.class.name.gsub(/Mailer$/, '').underscore }
  prepend_view_path ['app/views/mailers']

  default from: Settings.application.mailer_sender,
          reply_to: Settings.application.mailer

  private

  def application_logo
    attachments.inline['GliderPath-Academy-logo.png'] = { content: File.read("#{Rails.root}/app/assets/images/logo-default.png"), mime_type: 'image/png' }
  end
end
