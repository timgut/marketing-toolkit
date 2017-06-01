window.Toolkit ||= {}
window.Toolkit.Image ||= {}

window.Toolkit.Image.dropzone = ->
  window.Toolkit.resetDropzones()

  if $("#image-form").length isnt 0
    if window.Toolkit.isEditPage()
      flash = "Image updated!"
      dropMsg = "Drop image here to replace"
    else
      flash = "Image created!"
      dropMsg = "Drop image here to upload"

    window.Toolkit.dropzones.push(
      $("#image-form").dropzone({
        paramName: "image[image]",
        url: $("#image-form").attr("action"),
        dictDefaultMessage: "<h4>#{dropMsg}</h4><p class='or'>or</p><div class='button'>Select File</div>",
        error: ((errorMessage) ->
          $("#image-error").html(errorMessage.xhr.responseText)
        ),
        success: ((file, data) ->
          document.location.replace("/images?flash=#{flash}")
        )
      });
    )

window.Toolkit.Image.ready = ->
  window.Toolkit.optionsMenu()
  window.Toolkit.Image.dropzone()

$(document).on('turbolinks:load', window.Toolkit.Image.ready)
