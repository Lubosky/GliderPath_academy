$(document).on 'turbolinks:load', ->
  if !(typeof gon == 'undefined') &&  $('#credit-card-form').length > 0
    Stripe.setPublishableKey gon.stripe_public_key

    $form = $('#credit-card-form')

    stripeResponseHandler = (status, response) ->
      if response.error
        # Re-enable the submit button
        $form.find('button').removeAttr 'disabled'
        # show the errors on the form
        $('.has-errors').html response.error.message
      else
        # Get the token
        token = response['id']
        # Insert the token into the form so it gets submitted to the server
        $form.append $('<input type=\'hidden\' name=\'stripe_token\' />').val(token)
        # Submit the form
        $form.get(0).submit()
      return

    $form.submit (event) ->

      byAttr = (attr) ->
        $form.find('[data-stripe=\'' + attr + '\']')

      # Disable the submit button to prevent repeated clicks
      $form.find('button').prop 'disabled', false
      # createToken returns immediately
      # The supplied callback submits the form if there are no errors
      Stripe.createToken {
        number: byAttr('number').val()
        cvc: byAttr('cvc').val()
        exp_month: byAttr('exp-month').val()
        exp_year: byAttr('exp-year').val()
      }, stripeResponseHandler
      return false
      # Submit the form from callback
      true
    return
