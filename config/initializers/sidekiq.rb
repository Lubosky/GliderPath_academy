require 'sidekiq/web'

if ENV["REDIS_URL"]
  $redis_url = ENV["REDIS_URL"]
else
  host = ENV.fetch('REDIS_PORT_6379_TCP_HOST', 'localhost')
  port = ENV.fetch('REDIS_PORT_6379_TCP_PORT', '6379')
  $redis_url = "redis://#{host}:#{port}"
end

Sidekiq.configure_server do |config|
  config.redis = { url: $redis_url }
  config.server_middleware do |chain|
    chain.add RequestStoreMiddleware
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: $redis_url }
end

Sidekiq.default_worker_options = { backtrace: true, retry: 5, unique: :until_executed }
