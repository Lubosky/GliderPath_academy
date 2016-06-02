$(document).on 'turbolinks:load', ->
  $tabToggler = $('a[data-toggle=\'tab\']')
  $('.tabs').each ->
    $(this).children('.tab-header').first().children('a').addClass('is-active').next().addClass('is-open').show()

  $tabToggler.click (e) ->
    if !$(this).hasClass('is-active')
      e.preventDefault()
      accordionTabs = $(this).closest('.tabs')
      accordionTabs.find('.is-open').removeClass('is-open').hide()
      $(this).next().toggleClass('is-open').toggle()
      accordionTabs.find('.is-active').removeClass 'is-active'
      $(this).addClass 'is-active'
    else
      e.preventDefault()
