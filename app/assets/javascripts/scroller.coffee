$(document).on 'turbolinks:load', ->
  $('body').on 'click', '*[data-trigger=\'scroller\']', ->
    $body = $('body')
    toggler = $(this)
    attrHandle = toggler.attr('data-target-id')
    shelf = $body.find('*[data-shelf-id=\'' + attrHandle + '\']')
    $body.animate { scrollTop: shelf.offset().top - 80 }, 'slow'
