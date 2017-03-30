#= require selector-observer

observer = new SelectorObserver()

observer.add '[data-type~=course]', (courseCards) ->
  scheduledCourses = dataLayer.scheduledCourses
  courseCard = document.querySelectorAll('[data-type~=course]')
  index = 0
  courseCards.forEach (courseCard) ->
    courseId = courseCard.attributes['data-id'].value
    courseLink = courseCard.querySelector('[data-role~=course_link]')
    if scheduledCourses.indexOf(courseId) > -1
      courseLink.classList.add('disabled')
      courseLink.insertAdjacentHTML(
        'beforeend', '<span class="label label-scheduled">Coming Soon</span>'
      )
