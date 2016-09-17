module CacheHelper
  def cache_key_base
    [controller_name, action_name]
  end

  def index_cache_key(object)
    klass = object.to_s.classify.constantize
    count = klass.all.published.count
    timestamp = klass.all.map(&:updated_at).max.utc.to_s(:usec) if klass.any?
    [count, timestamp]
  end
end
