$(document).on 'turbolinks:load', ->
  if $('#sortable').length > 0
    byId = (id) ->
      document.getElementById id

    byAttr = (attr) ->
      $('body').find('*[data-element=\'' + attr + '\']')

    section_positions = ->
      section = byAttr('section')
      section.each (i) ->
        $(this).attr 'data-position', i + 1

    lesson_positions = ->
      lesson = byAttr('lesson')
      lesson.each (i) ->
        $(this).attr 'data-position', i + 1

    Sortable.create byId('sortable'),
      animation: 150
      draggable: '.draggable-list'
      ghostClass: 'draggable-placeholder'
      chosenClass: 'is-dragged'
      handle: '.icon-draggable'

      onEnd: (e) ->
        section = byAttr('section')
        lesson = byAttr('lesson')

        section_order = []
        lesson_order = []
        lesson_positions()
        section_positions()

        lesson.each (i) ->
          lesson_order.push
            lesson_id: $(this).data('lesson-id')
            position: i + 1

        section.each (i) ->
          section_order.push
            section_id: $(this).data('section-id')
            position: i + 1

        $.ajax
          async: true
          type: 'PUT'
          url: $(byId('sortable')).data('url')
          data:
            sort_lessons: lesson_order
            sort_sections: section_order

    [].forEach.call byId('sortable').getElementsByClassName('step-list'), (el) ->
      Sortable.create el,
        animation: 150
        draggable: '.list-item'
        ghostClass: 'draggable-placeholder'
        chosenClass: 'is-dragged'
        group: 'lesson'
        handle: '.icon-holder'

        onEnd: (e) ->
          lesson = byAttr('lesson')
          updated_order = []
          lesson_positions()

          lesson.each (i) ->
            updated_order.push
              id: $(this).data('lesson-id')
              section_id: $(this).parent().data('section-id')
              position: i + 1

          $.ajax
            async: true
            type: 'PUT'
            url: $(byId('sortable')).data('url')
            data:
              lesson_order: updated_order
