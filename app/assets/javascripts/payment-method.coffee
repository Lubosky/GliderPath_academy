$(document).on 'turbolinks:load', ->
  unless typeof gon is 'undefined'
    clientToken = gon.braintree_client_token
    braintree.setup clientToken, 'dropin',
      container: 'braintree-payment-method-form'
      form: 'payment-method-form'
      onError: ->
        $button = $('#payment-method-form').find('.button')
        enableButton = ->
          if $button.attr('disabled')
            $button.removeProp 'disabled'
            $button.empty().text('Save payment method')
          else
            setTimeout enableButton, 500
        enableButton()
