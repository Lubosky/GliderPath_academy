if Rails.env.development?
  require 'rack-mini-profiler'

  Rack::MiniProfilerRails.initialize!(Rails.application)

  Rails.application.middleware.swap(Rack::Deflater, Rack::MiniProfiler)
  Rails.application.middleware.swap(Rack::MiniProfiler, Rack::Deflater)
end
