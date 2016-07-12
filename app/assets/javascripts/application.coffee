#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require cocoon
#= require growl
#= require accordion
#= require avatar-preview
#= require checkout
#= require dropdown
#= require refile
#= require payment-method
#= require purchase
#= require revealer
#= require scroller
#= require subscription
#= require tabs
#= require_tree .

$(document).on 'turbolinks:load', ->
  $html = $('html')
  $('#menu-toggle').data('toggle', 'mobile-menu').click ->
    $html.toggleClass 'menu-expanded'

  $('nav .menu-item > a').click ->
    if $html.hasClass 'menu-expanded'
      $html.removeClass 'menu-expanded'

  $('a.disabled').click (e) ->
    e.preventDefault()
