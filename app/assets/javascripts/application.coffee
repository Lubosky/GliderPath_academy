#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require cocoon
#= require growl
#= require accordion
#= require avatar-preview
#= require checkout
#= require credit-card
#= require dropdown
#= require html.sortable
#= require initials
#= require refile
#= require observer
#= require purchase
#= require revealer
#= require scroller
#= require sortable
#= require subscription
#= require tabs
#= require fastclick

$ ->
  FastClick.attach document.body

$(document).on 'click', 'a.disabled', (e)->
  e.preventDefault()

$(document).on 'turbolinks:load', ->
  $html = $('html')
  $('#menu-toggle').data('toggle', 'mobile-menu').click ->
    $html.toggleClass 'menu-expanded'

  $('nav .menu-item > a').click ->
    if $html.hasClass 'menu-expanded'
      $html.removeClass 'menu-expanded'

  content = $('*[data-layout-element=\'content\']')
  footer = $('*[data-layout-element=\'footer\']')
  height = $(window).height() - footer.outerHeight()
  content.attr 'style', 'min-height:' + height + 'px'

  change_visibility = (status) ->
    datetime = $('*[data-toggle=\'datetimepicker\']')
    if status == 'Scheduled'
      datetime.show()
    else
      datetime.hide()

  datetimepicker = $('*[data-trigger=\'datetimepicker\'] > select')

  change_visibility datetimepicker.val()
  datetimepicker.on 'change', (e) ->
    change_visibility datetimepicker.val()
