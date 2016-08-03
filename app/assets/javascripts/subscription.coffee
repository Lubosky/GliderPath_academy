$(document).on 'turbolinks:load', ->
  if !(typeof gon == 'undefined') &&  $('#braintree-subscription-form').length > 0
    clientToken = gon.braintree_client_token
    braintree.setup clientToken, 'dropin',
      container: 'braintree-subscription-form'
      form: 'subscription-form'
      paypal:
        singleUse: false
        currency: 'USD'
        locale: 'en_us'
      dataCollector: paypal: true
      onError: ->
        $button = $('#subscription-form').find('.button')
        enableButton = ->
          if $button.attr('disabled')
            $button.removeProp 'disabled'
            $button.empty().text('Subscribe')
          else
            setTimeout enableButton, 500
        enableButton()
