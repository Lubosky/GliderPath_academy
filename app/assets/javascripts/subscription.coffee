$(document).on 'turbolinks:load', ->
  unless typeof gon is 'undefined'
    clientToken = gon.braintree_client_token
    braintree.setup clientToken, 'dropin',
      container: 'braintree-subscription-form'
      form: 'subscription-form'
      paypal:
        singleUse: false
        currency: 'USD'
        locale: 'en_us'
      dataCollector: paypal: true
