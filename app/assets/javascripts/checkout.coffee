$(document).on 'turbolinks:load', ->
  $registrationFormToggler = $('a[data-toggle=\'registration-form\']')
  $signinFormToggler = $('a[data-toggle=\'signin-form\']')
  $('.checkout .signin-form').hide()
  $registrationFormToggler.click (event) ->
    event.preventDefault()
    $('.registration-form').show()
    $('.signin-form').hide()
  $signinFormToggler.click (event) ->
    event.preventDefault()
    $('.signin-form').show()
    $('.registration-form').hide()
