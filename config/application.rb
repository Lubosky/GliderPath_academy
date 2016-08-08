require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GliderPathAcademy
  class Application < Rails::Application
    config.generators do |generate|
      generate.assets false
      generate.factory_girl false
      generate.helper false
    end

    config.assets.precompile += %w(mailer.css)

    config.autoload_paths += [
      "#{config.root}/lib",
      "#{config.root}/vendor/lib"
    ]

    config.middleware.use Rack::Deflater

    config.sass.preferred_syntax = :sass

    config.i18n.default_locale = :en
    I18n.config.enforce_available_locales = true

    config.action_mailer.default_url_options = { host: ENV.fetch('SMTP_1_DOMAIN', 'lvh.me:3000') }
    config.action_mailer.smtp_settings = {
      address: ENV.fetch('SMTP_1_ADDRESS', 'localhost'),
      port: ENV.fetch('SMTP_1_PORT', 1025).to_i,
      domain: ENV.fetch('SMTP_1_DOMAIN', 'lvh.me:3000'),
      authentication: ENV.fetch('SMTP_1_AUTHENTICATION', nil),
      enable_starttls_auto: ENV.fetch('SMTP_1_ENABLE_STARTTLS_AUTO', 'false') == 'true',
      user_name: ENV.fetch('SMTP_1_USER_NAME', nil),
      password: ENV.fetch('SMTP_1_PASSWORD', nil),
      openssl_verify_mode: ENV.fetch('SMTP_1_OPENSSL_VERIFY_MODE', nil),
    }
  end
end
