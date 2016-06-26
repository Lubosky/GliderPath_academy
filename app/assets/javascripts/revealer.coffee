$(document).on 'turbolinks:load', ->
  $('body').on 'click', '*[data-trigger=\'revealer\']', ->
    toggler = $(this)
    if toggler.attr('data-revealer-id')
      attrHandle = toggler.attr('data-revealer-id')
      shelf = $('body').find('*[data-shelf-id=\'' + attrHandle + '\']')
      height = 0
      shelf.children().each ->
        height = height + $(this).outerHeight(true)
    if 0 != shelf.length
      shelf.toggleClass('is-open')
    if shelf.hasClass('is-open')
      shelf.css('height', height)
    else
      shelf.css('height', 0)
