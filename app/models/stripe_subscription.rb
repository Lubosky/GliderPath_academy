class StripeSubscription
  attr_reader :id

  def initialize(subscription)
    @subscription = subscription
  end

  def create
    rescue_stripe_exception do
      ensure_customer_exists
      update_subscription
    end
  end

  private

  attr_reader :stripe_customer

  def rescue_stripe_exception
    yield
    true
  rescue Stripe::StripeError => exception
    @subscription.errors[:base] <<
      I18n.t('flash.payment.problem_with_card', message: exception.message)
    false
  end

  def ensure_customer_exists
    @stripe_customer = StripeCustomer.new(
      @subscription.subscriber,
      @subscription.stripe_token
    ).ensure_customer_exists
  end

  def update_subscription
    if stripe_customer.subscriptions.total_count.zero?
      subscription =
        stripe_customer.subscriptions.create(stripe_subscription_attributes)
    else
      subscription = stripe_customer.subscriptions.first
      stripe_subscription_attributes.each { |key, value| subscription[key] = value }
      subscription.save
    end

    @id = subscription.id
  end

  def stripe_subscription_attributes
    {
      plan: @subscription.stripe_plan_id
    }
  end
end
