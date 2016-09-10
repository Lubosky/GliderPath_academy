require Rails.root.join('config/initializers/mail')

Rails.application.configure do
  config.cache_classes = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.assets.js_compressor = :uglifier
  config.assets.compile = true

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  if ENV["REDIS_CACHE_URL"].present?
    config.cache_store = :readthis_store, {
      expires_in: 1.week.to_i,
      namespace: 'cache',
      compress: true,
      compression_threshold: 2.kilobytes,
      redis: { url: ENV.fetch("REDIS_CACHE_URL"), driver: :hiredis }
    }
  end

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default(charset: 'utf-8')
  config.action_mailer.perform_caching = false
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.smtp_settings = SMTP_SETTINGS

  config.eager_load = true
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify

  config.log_level = :warn
  config.log_tags = [:request_id]
  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false
end
