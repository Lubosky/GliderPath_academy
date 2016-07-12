class ContactForm < MailForm::Base

  append :remote_ip, :user_agent

  attribute :name,        validate: true
  attribute :email,       validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :subject,     validate: true
  attribute :message,     validate: true
  attributes :gliderbot,  captcha: true

  def headers
    {
      subject: "[#{Settings.application.name}] - #{subject}",
      to: Settings.company.email,
      from: %("#{name}" <#{email}>),
      reply_to: %(#{email})
    }
  end

end
