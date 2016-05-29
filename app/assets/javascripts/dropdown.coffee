$(document).on 'turbolinks:load', ->
  $dropdownToggler = $('a[data-toggle=\'dropdown\']')
  $html = $('html')
  $dropdownToggler.click (e) ->
    e.stopPropagation()
    $('.dropdown').toggleClass 'is-open'

  $profileToggler = $('nav a[data-toggle=\'dropdown\']')
  $profileToggler.click (e) ->
    if $html.hasClass 'menu-expanded'
      $('.dropdown').removeClass 'is-open'
    else
      e.preventDefault()

  $html.on 'click', (e) ->
    $target = $(e.target)
    if !$target.parents().hasClass('dropdown')
      $('.dropdown').removeClass 'is-open'

  $html.on 'keyup', (e) ->
    ESCAPE_KEY = 27
    if e.which == ESCAPE_KEY
      $('.dropdown').removeClass 'is-open'
