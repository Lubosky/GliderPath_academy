class RequestStoreMiddleware
  def call(worker, msg, queue)
    yield
  ensure
    ::RequestStore.clear! if defined?(::RequestStore)
  end
end
