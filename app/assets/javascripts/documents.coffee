window.Toolkit ||= {}
window.Toolkit.Document ||= {}

window.Toolkit.Document.addImage = ->
  # Init image picker
  $(".image-picker").addClass("image-picker_open")
  
  $("#image-picker").popup({
    opacity: '0.8',
    color: 'black'
  })

  $('#add_image_button').attr('disabled','disabled').addClass('disabled')
  
  # Get images and populate .image-grid
  $(document).on("click", ".image-picker", ->
    $target = $("#image-picker .image-grid")

    if $target.attr("data-loaded") is "false"
      $.get("/images/choose", (data) ->
        $target.html(data)
        $target.attr("data-loaded", "true")
        window.Toolkit.Document.dropzone()
      ).fail((data) ->
        $("#image-picker .image-grid").html("There was a problem retrieving your images. Please try again.")
      )
  )

  # Stylize only the selected image
  $(document).on("click", ".image-grid > figure", ->
    $(@).addClass('enabled')
    $(@).siblings().each( ->
      $(@).removeClass('enabled')
    )

    $('#add_image_button').removeAttr('disabled').removeClass('disabled')
  )

  # Close the modal and assign the selected image to the target input
  $("#add_image_button").click( ->
    $target = $("##{$("#image-picker").attr("data-target")}")                # The field where the value is set
    value   = $("#image-picker").find("figure.enabled img").attr("src")      # The value to set on the field
    $em     = $("label[for='#{$("#image-picker").attr("data-target")}'] em") # The parent tag that controls the modal
    $strong = $em.find("strong")                                             # The text that launches the modal
    $a      = $em.find("a")                                                  # The link that launches the modal
    
    # Assign the value to the input
    $target.val(value)
    $target.prop("checked", true)
    $target.trigger("change")

    # Clean up any previously selected image
    $em.find("img").remove()

    # Display the selected image
    $em.addClass("cf")
    $em.prepend("<figure><img src='#{value}' /></figure>")
    $strong.text("Change Photo")
    $a.addClass("loaded")

    # Clean up the modal div
    $("#image-picker").popup("hide")
    $("#image-picker").removeAttr("data-target")
    $("#image-picker").find("figure.enabled").removeClass("enabled")
  )

  # Let the modal know which input to apply the selection to
  $(".image-picker").click( ->
    $("#image-picker").attr("data-target", $(@).attr("data-target"))
  )

window.Toolkit.Document.saveButton = ->
  $("[data-save='true']").click( ->
    $("form[data-document='true']").submit()
  )

window.Toolkit.Document.fillForm = ->
  $.each(window.Toolkit.Document.savedData, (key, data) ->
    if data.fieldID
      # Check the field and trigger a change
      $field = $("##{data.fieldID}")
      $field.prop("checked", true)
      $field.trigger("change")

      # If there is a custom field, fill in the value
      if $field.attr("data-custom")?
        switch $field.attr("data-custom")
          when "text"
            # Some forms contain checkboxes with a custom field, where the custom field's ID ends in "-custom"
            # Other forms contain only custom fields, where every field ID ends in "-custom"
            # This if/else block looks for the correct ID in the form based on the datum's field_id attribute.
            if data.fieldID.indexOf("custom") is -1
              customSelector = "##{data.fieldID}-custom"
            else
              customSelector = "##{data.fieldID}"

            $customField = $(customSelector)
            $customField.val(data.value)
            $customField.trigger("change")
          when "combine"
            $customFields = $("label[for='#{data.fieldID}']").find("[data-combine-tag]")

            # Put the custom text here so we can parse it with jQuery
            $("#custom-text").html(data.value)

            $.each($customFields, (i, field) ->
              # Use data-combine-tag to get the value for this field out of $value
              tag = $(field).attr("data-combine-tag")
              value = $("#custom-text").find(tag)
              $(field).val(value.text())
              $(field).trigger("change")
            )

            # Erase the custom text in case another field needs to use it.
            $("#custom-text").html("")
          when "image"
            $em     = $("label[for='#{data.fieldID}'] em")
            $strong = $em.find("strong")
            $a      = $em.find("a")

            # Set the value
            $field.val(data.value)

            # Display the selected image
            $em.addClass("cf")
            $em.prepend("<figure><img src='#{data.value}' /></figure>")
            $strong.text("Change Photo")
            $a.addClass("loaded")
          else
            console.log("Don't know how to fill in #{$field.attr("data-custom")}")
  )

window.Toolkit.Document.saveIds = ->
  $("form[data-document='true']").on("change", "[data-persist-id]", ->
    $target = $("[name='#{$(@).attr("data-persist-id")}']")
    value = $(@).attr("id")
    $target.val(value)
  )

# Disable the "Download" button if the form is changed
window.Toolkit.Document.disableDownloadButton = ->
  $(document).on("click", "a.disabled", (e) ->
    e.preventDefault()
    return false
  )
  $(document).on("change", "form[data-document='true']", ->
    $("[data-download='true']").addClass("disabled")
    $("[data-download='true']").prop("title", "This document must be saved before it can be downloaded.")
  )

 window.Toolkit.Document.dropzone = ->
  window.Toolkit.resetDropzones() # This throws an error. Not sure why.

  if $("#upload-photo-form").length isnt 0
    window.Toolkit.dropzones.push(
      $("#upload-photo-form").dropzone({
        paramName: "image[image]",
        url: "/images",
        dictDefaultMessage: "DROP IMAGE HERE TO UPLOAD",
        error: ((errorMessage) ->
          $("#image-error").html(errorMessage.xhr.responseText)
          @.removeAllFiles()
        ),
        success: ((file, json) ->
          $("#image-picker .image-grid").append("
            <figure>
              <img src='#{json.url}' alt='#{file.name}' />
              <figcaption>#{file.name}</figcaption>
            </figure>
          ")

          @.removeFile(file)
        )
      });
    )

window.Toolkit.Document.ready = ->
  window.Toolkit.Document.addImage()
  window.Toolkit.Document.saveButton()
  window.Toolkit.optionsMenu()
  window.Toolkit.Document.saveIds()
  window.Toolkit.Document.fillForm()
  window.Toolkit.Document.disableDownloadButton()

$(document).on('turbolinks:load', window.Toolkit.Document.ready)
