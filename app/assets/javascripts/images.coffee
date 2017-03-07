window.Toolkit ||= {}
window.Toolkit.Image ||= {}

window.Toolkit.Image.dropzone = ->
  window.Toolkit.resetDropzones()

  if $("#image-form").length isnt 0
    window.Toolkit.dropzones.push(
      $("#image-form").dropzone({
        paramName: "image[image]",
        url: $("#image-form").attr("action"),
        dictDefaultMessage: "Drop image here to upload"
      });
    )

window.Toolkit.Image.croppie = ->
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

window.Toolkit.Image.readFile = (input) ->
  if input.files && input.files[0]
    reader = new FileReader();

    reader.onload = (e) ->
      $('#upload-crop').croppie('bind', {
        url: e.target.result
      })

    reader.readAsDataURL(input.files[0])

window.Toolkit.Image.ready = ->
  console.log "images ready"
  window.Toolkit.Image.dropzone()
  # window.Toolkit.Image.croppie()
  # $("#image_image").on("change", -> window.Toolkit.Image.readFile(this))

$(document).on('turbolinks:load', window.Toolkit.Image.ready)
