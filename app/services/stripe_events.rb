class StripeEvents
  def initialize(event)
    @event = event
  end

  def customer_subscription_deleted
    if subscription
      Cancellation.new(subscription: subscription).process
    end
  end

  private

  def subscription
    if subscription = Subscription.find_by(stripe_subscription_id: stripe_subscription.id)
      subscription
    else
      Rollbar.error(
        error_message: "No subscription found for #{stripe_subscription.id}",
        error_class: 'StripeEvents',
        parameters: @event.to_hash
      )
      nil
    end
  end

  def stripe_subscription
    @event.data.object
  end
end
