require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GliderPathAcademy
  class Application < Rails::Application

    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |generate|
      generate.factory_girl false
      generate.helper false
    end

    config.sass.preferred_syntax = :sass

    config.i18n.default_locale = :en
    I18n.config.enforce_available_locales = true

    config.action_mailer.default_url_options = { :host => ENV.fetch('SMTP_1_DOMAIN', 'lvh.me:3000') }
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
