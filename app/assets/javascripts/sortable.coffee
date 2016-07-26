$(document).on 'turbolinks:load', ->
  byId = (id) ->
    document.getElementById id

  section_positions = ->
    section = $('body').find('*[data-layout-element=\'section\']')
    section.each (i) ->
      $(this).attr 'data-position', i + 1

  lesson_positions = ->
    lesson = $('body').find('*[data-layout-element=\'lesson\']')
    lesson.each (i) ->
      $(this).attr 'data-position', i + 1

  Sortable.create byId('sortable'),
    animation: 150
    draggable: '.draggable-list'
    ghostClass: 'draggable-placeholder'
    chosenClass: 'is-dragged'
    handle: '.icon-draggable'

    onEnd: (e) ->
      section = $('body').find('*[data-layout-element=\'section\']')

      updated_order = []
      section_positions()

      section.each (i) ->
        updated_order.push
          id: $(this).data('section-id')
          position: i + 1

  [].forEach.call byId('sortable').getElementsByClassName('step-list'), (el) ->
    Sortable.create el,
      animation: 150
      draggable: '.list-item'
      ghostClass: 'draggable-placeholder'
      chosenClass: 'is-dragged'
      group: 'lesson'
      handle: '.icon-holder'

      onEnd: (e) ->
        lesson = $('body').find('*[data-layout-element=\'lesson\']')
        updated_order = []
        lesson_positions()

        lesson.each (i) ->
          updated_order.push
            id: $(this).data('lesson-id')
            section_id: $(this).parent().data('section-id')
            position: i + 1

        $.ajax
          type: 'PUT'
          url: $(byId('sortable')).data('url')
          data:
            order: updated_order
