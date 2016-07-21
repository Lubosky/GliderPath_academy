$(document).on 'turbolinks:load', ->
  unless typeof gon is 'undefined'
    clientToken = gon.braintree_client_token
    braintree.setup clientToken, 'dropin',
      container: 'braintree-purchase-form'
      form: 'purchase-form'
      paypal:
        singleUse: false
        currency: 'USD'
        locale: 'en_us'
      dataCollector:
        paypal: true
      onError: ->
        $button = $('#purchase-form').find('.button')
        enableButton = ->
          if $button.attr('disabled')
            $button.removeProp 'disabled'
            $button.empty().text('Purchase')
          else
            setTimeout enableButton, 500
        enableButton()
