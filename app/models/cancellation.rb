class Cancellation
  include ActiveModel::Model

  def initialize(subscription:)
    @subscription = subscription
  end

  def schedule
    if valid?
      cancel_at_period_end
      true
    else
      false
    end
  end

  def process
    if @subscription.active?
      @subscription.cancel
    end
  end

  def subscribed_plan
    @subscription.plan
  end

  private

  def cancel_at_period_end
    Subscription.transaction do
      stripe_customer.subscriptions.first.delete(at_period_end: true)
      record_date_when_subscription_will_cancel
      track_cancelled
    end
  end

  def track_cancelled
    Analytics.new(@subscription.subscriber).track_cancelled
  end

  def record_date_when_subscription_will_cancel
    @subscription.update_column(
      :scheduled_for_cancellation_on,
      end_of_billing_period,
    )
  end

  def stripe_customer
    @stripe_customer ||= Stripe::Customer.retrieve(stripe_customer_id)
  end

  def stripe_customer_id
    @subscription.subscriber.stripe_customer_id
  end

  def end_of_billing_period
    Time.zone.at(stripe_customer.subscriptions.first.current_period_end)
  end
end
