avatarPreview = (input) ->
  if input.files and input.files[0]
    reader = new FileReader
    reader.onload = (e) ->
      $('#preview_img').attr 'src', e.target.result
    reader.readAsDataURL input.files[0]

$(document).on 'change', 'input#previewable', ->
  avatarPreview this
