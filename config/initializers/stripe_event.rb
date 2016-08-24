StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    Chargify.new(event.data.object).process
  end

  events.subscribe 'customer.subscription.updated' do |event|
    StripeEvents.new(event).customer_subscription_updated
  end

  events.subscribe 'customer.subscription.deleted' do |event|
    StripeEvents.new(event).customer_subscription_deleted
  end
end
