$(document).on 'turbolinks:load', ->
  $('*[data-layout-element=\'avatar\']').map ->
    avatar = $(this)
    name = avatar.data('name')
    initials = name.match(/\b(\w)/g).join('').substr(0, 3).toUpperCase()
    avatar.html(initials)
