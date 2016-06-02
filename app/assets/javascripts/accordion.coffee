$(document).on 'turbolinks:load', ->
  $accordionToggler = $('a[data-toggle=\'accordion\']')
  $accordionToggler.bind 'click', (e) ->
    $that = $(this)
    $parent = $that.parents().eq(1)
    if $parent.hasClass 'is-closed'
      e.preventDefault()
      $parent.find('li:not([class^=\'step-list\'])').slideDown 300
      $parent.removeClass('is-closed').addClass('is-open')
    else
      e.preventDefault()
      $parent.find('li:not([class^=\'step-list\'])').slideUp 300
      $parent.removeClass('is-open').addClass('is-closed')
