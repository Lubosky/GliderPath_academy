class CancelSubscriptionWorker
  include Sidekiq::Worker

  def perform(subscriber_id, subscription_id)
    subscriber = User.find_by_id(subscriber_id)
    result = Braintree::Subscription.cancel(subscription_id)
    subscriber.subscription.cancel unless !result.success?
  end

end

