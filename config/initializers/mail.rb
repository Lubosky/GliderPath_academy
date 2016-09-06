if Rails.env.production?
  SMTP_SETTINGS = {
    address: ENV['SMTP_ADDRESS'],
    port: '587',
    domain: 'gliderpath.com',
    authentication: :plain,
    enable_starttls_auto: true,
    user_name: ENV['SMTP_USERNAME'],
    password: ENV['SMTP_PASSWORD']
  }
end
