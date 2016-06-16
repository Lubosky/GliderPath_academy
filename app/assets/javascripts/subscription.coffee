$ ->
  unless typeof gon is 'undefined'
    clientToken = gon.braintree_client_token
    braintree.setup clientToken, 'dropin',
      container: 'payment-form'
      form: 'subscription-form'
      paypal:
        singleUse: false
        currency: 'USD'
        locale: 'en_us'
      dataCollector: paypal: true