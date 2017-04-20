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

    $('#add_image_button').removeAttr('disabled')
  )

  # Close the modal and assign the selected image to the target input
  $(document).on("click", "#add_image_button", ->
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
    $('#add_image_button').attr("disabled", "disabled")
    $("#image-picker .upload-image").show()
    $(document).off("ajax:success", "#image-picker .edit_image")
    $(document).off("ajax:error", "#image-picker .edit_image")
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
      # Assign the saved value to the field
      $field = $("##{data.fieldID}")
      
      switch $field.attr("type")
        when "hidden"
          $field.val(data.value)
        else
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
  $form        = $("form[data-document='true']") # The form object
  $dataFields  = $form.find("[name^=data]")      # All fields whose data are saved
  hiddenFields = []                              # Many $dataFields share the same name. Use this to make sure we don't have duplicates.

  $.each($dataFields, (i, field) ->
    $field = $(field)                         # A jQuery object of the data field
    name   = "select_#{$field.attr('name')}"  # The name attribute for the hidden field
    id     = $(@).attr("id")                  # The id attribute of the data field

    # Add a hidden field to the form to save the IDs of the selected fields, but don't create duplicate fields.
    if hiddenFields.indexOf(name) is -1
      $form.prepend("<input type='hidden' name='#{name}' value='' />")
      hiddenFields.push(name)

    # Add an event listener for this field to populate the hidden field when it's changed
    $("form[data-document='true']").on("change", "##{id}", ->
      $target = $("[name='#{name}']")
      $target.val(id)
    )
  )

window.Toolkit.Document.dataTarget = ->
  # When a custom value is entered, change the value in the actual field
  if window.Toolkit.init.documentDataTarget is false
    window.Toolkit.init.documentDataTarget = true
    $(document).on("change", "[data-target]", ->
      $target = $("##{$(@).attr('data-target')}")
      $target.val($(@).val())
    )

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
  $form = $("form[data-document='true']")
  croppable = $form.attr("data-crop-enabled") is "true"
  window.Toolkit.dropzones = []

  if $("#upload-photo-form").length isnt 0
    try
      window.Toolkit.dropzones.push(
        # Initialize Dropzone
        $("#upload-photo-form").dropzone({
          paramName: "image[image]",
          url: "/images",
          dictDefaultMessage: "<h4>DROP IMAGE HERE TO UPLOAD</h4><p class='or'>or</p><div class='button'>Select File</div>",
          
          # Callback when the image cannot be uploaded
          error: ((errorMessage) ->
            $("#image-error").html(errorMessage.xhr.responseText)
            @.removeAllFiles()
          ),
          
          # Callback when the image is uploaded
          success: ((file, data) ->
            if croppable
              # Get the image crop form
              # url = "/images/#{data.id}/crop?modal=true&context=#{$form.attr("data-crop-context")}&context_height=#{$form.attr("data-context-height")}&context_width=#{$form.attr("data-context-width")}"
              url = "/images/#{data.id}/crop?modal=true&template_id=#{$form.attr("data-template-id")}"
              $.get(url, (data) =>
                @.removeFile(file)

                $("#image-picker .upload-image, #image-picker .select-image").hide( ->
                  $("#image-picker .crop-image").html(data).show(->
                    $(".drag").draggable({
                      # containment: "window",
                      drag: (event, ui) ->
                        # Event has several x,y properties that may be useful here.
                        # Update form fields
                        $("#ss_bg_x").val(ui.position.top)
                        $("#ss_bg_y").val(ui.position.left)
                    })
                    
                    # Keep track of oriignal position so we know where to crop
                    $(".drag").data({
                      originalLeft: $("#draggable").css('left'),
                      origionalTop: $("#draggable").css('top')
                    });
                  )

                  $(document).on("ajax:success", "#image-picker .edit_image", (e, data, status, xhr) ->
                    e.preventDefault()

                    # Clear out this image's data in case the user wants to crop another image
                    $("#image-picker .crop-image").html("")
                    
                    $("#image-picker .crop-image").hide(->
                      $("#image-picker .select-image").show()
                    )

                    # Add the image to the grid and select it
                    $("#image-picker .crop-image").hide( ->
                      $("#image-picker .image-grid").append("
                        <figure>
                          <img src='#{data.cropped_url}' alt='#{data.file_name}' />
                          <figcaption>#{data.file_name}</figcaption>
                        </figure>
                      ")

                      $(".image-grid figure:last").click()
                    )

                  # When the image cannot be cropped
                  ).on("ajax:error", (e, xhr, status, error) ->
                    $("#image-error").html("There was an error cropping your image. Please try again.")
                  )
                )
              )
            else
              $("#image-picker .crop-image").hide( ->
                $("#image-picker .image-grid").append("
                  <figure>
                    <img src='#{data.cropped_url}' alt='#{data.file_name}' />
                    <figcaption>#{data.file_name}</figcaption>
                  </figure>
                ")

                $(".image-grid figure:last").click()
              )
          )
        });
      )
    catch
      # Dropzone will throw an error if it's being initialized multiple times.
      # This shouldn't cause a problem, but you never know.
      # console.log "Dropzone already attached"

window.Toolkit.Document.ready = ->
  if window.Toolkit.isDocumentPage()
    window.Toolkit.Document.addImage()
    window.Toolkit.Document.saveButton()
    window.Toolkit.optionsMenu()
    window.Toolkit.Document.saveIds()
    window.Toolkit.Document.fillForm()
    window.Toolkit.Document.dataTarget()
    window.Toolkit.Document.disableDownloadButton()

    # Event listener for resizing the image
    $(document).on("input", "#resize-image", ->
      change    = parseInt($(@).val()) / 100
      imgHeight = Math.ceil(parseFloat($("#croparea").attr("data-height")) * change)
      imgWidth  = Math.ceil(parseFloat($("#croparea").attr("data-width"))  * change)

      $("#uploaded").css({height: "#{imgHeight}px", width: "#{imgWidth}px"})

      # Update form fields
      $("#image_image_size_w").val(imgWidth)
      $("#image_image_size_h").val(imgHeight)

      $(".drag").css({top: 0, left: 0})
      $("#ss_bg_x").val(0)
      $("#ss_bg_y").val(0)
    )

$(document).on('turbolinks:load', window.Toolkit.Document.ready)
