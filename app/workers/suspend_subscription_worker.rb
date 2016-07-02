class SuspendSubscriptionWorker
  include Sidekiq::Worker

  def perform(subscription_id)
    subscription = Subscription.find_by_braintree_subscription_id(subscription_id)
    subscription.suspend if subscription.active?
  end

end

