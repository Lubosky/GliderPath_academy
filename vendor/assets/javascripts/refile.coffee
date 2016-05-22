do ->

  isSuccess = (xhr) ->
    xhr.status >= 200 and xhr.status < 300 or xhr.status == 304

  formData = (as, file, fields) ->
    data = new FormData
    if fields
      Object.keys(fields).forEach (key) ->
        data.append key, fields[key]
        return
    data.append as, file
    data

  'use strict'
  if !document.addEventListener
    return

  document.addEventListener 'change', (changeEvent) ->
    input = changeEvent.target
    if input.tagName == 'INPUT' and input.type == 'file' and input.getAttribute('data-direct')
      if !input.files
        return

      reference = input.getAttribute('name')
      metadataField = document.querySelector('input[type=hidden][name=\'' + reference + '\']')

      url = input.getAttribute('data-url')
      fields = JSON.parse(input.getAttribute('data-fields') or 'null')
      requests = [].map.call(input.files, (file, index) ->
        xhr = new XMLHttpRequest

        dispatchEvent = (element, name, progress) ->
          ev = document.createEvent('CustomEvent')
          ev.initCustomEvent name, true, false,
            xhr: xhr
            file: file
            index: index
            progress: progress
          element.dispatchEvent ev
          return

        xhr.file = file
        xhr.addEventListener 'load', ->
          xhr.complete = true
          if requests.every(((xhr) ->
              xhr.complete
            ))
            finalizeUpload()
          if isSuccess(xhr)
            dispatchEvent input, 'upload:success'
          else
            dispatchEvent input, 'upload:failure'
          dispatchEvent input, 'upload:complete'
          return
        xhr.upload.addEventListener 'progress', (progressEvent) ->
          dispatchEvent input, 'upload:progress', progressEvent
          return
        if input.getAttribute('data-presigned')
          dispatchEvent input, 'presign:start'
          presignXhr = new XMLHttpRequest
          presignUrl = url + '?t=' + Date.now() + '.' + index
          presignXhr.addEventListener 'load', ->
            dispatchEvent input, 'presign:complete'
            if isSuccess(presignXhr)
              dispatchEvent input, 'presign:success'
              data = JSON.parse(presignXhr.responseText)
              xhr.id = data.id
              xhr.open 'POST', data.url, true
              xhr.send formData(data.as, file, data.fields)
              dispatchEvent input, 'upload:start'
            else
              dispatchEvent input, 'presign:failure'
              xhr.complete = true
            return
          presignXhr.open 'GET', presignUrl, true
          presignXhr.send()
        else
          xhr.open 'POST', url, true
          xhr.send formData(input.getAttribute('data-as'), file, fields)
          dispatchEvent input, 'upload:start'
        xhr
      )
      if requests.length
        input.classList.add 'uploading'

      finalizeUpload = ->
        input.classList.remove 'uploading'
        if requests.every(isSuccess)
          data = requests.map((xhr) ->
            id = xhr.id or JSON.parse(xhr.responseText).id
            {
              id: id
              filename: xhr.file.name
              content_type: xhr.file.type
              size: xhr.file.size
            }
          )
          if !input.multiple
            data = data[0]
          if metadataField
            metadataField.value = JSON.stringify(data)
          input.removeAttribute 'name'
