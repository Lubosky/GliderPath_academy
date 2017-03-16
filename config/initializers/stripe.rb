Stripe.api_key = ENV['STRIPE_API_KEY'] || 'stripe_api_key'
STRIPE_PUBLIC_KEY = ENV['STRIPE_PUBLIC_KEY'] || 'stripe_public_key'
Stripe.api_version = '2017-02-14'

unless defined? STRIPE_JS_HOST
  STRIPE_JS_HOST = 'https://js.stripe.com'
end
