window.Toolkit ||= {}

window.Toolkit.imageReady = ->
  if document.getElementById("croppie")
    window.Toolkit.croppie = new Croppie(
      document.getElementById("croppie"),
      {
        enableExif: true,
        viewport: {
            width:  800,
            height: 640,
            type:   'square'
        },
        boundary: {
            width:  900,
            height: 740
        }
      }
    )

  window.Toolkit.readFile = (input) ->
    if input.files && input.files[0]
      reader = new FileReader();

      reader.onload = (e) ->
        $('#upload-crop').croppie('bind', {
          url: e.target.result
        })

      reader.readAsDataURL(input.files[0])

  $("#image_image").on("change", -> window.Toolkit.readFile(this))


$(document).on('turbolinks:load', window.Toolkit.imageReady)
