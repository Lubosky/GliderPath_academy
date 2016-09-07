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

    config.eager_load_paths << Rails.root.join('lib')
    config.eager_load_paths += [Rails.root.join('vendor', 'lib')]

    config.middleware.use Rack::Deflater

    config.sass.preferred_syntax = :sass

    config.i18n.default_locale = :en
    I18n.config.enforce_available_locales = true

    config.action_mailer.default_url_options = {
      host: ENV['APP_DOMAIN'],
      protocol: 'https'
    }
  end
end
