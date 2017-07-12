window.Toolkit ||= {}
window.Toolkit.Document ||= {}

## trivial change to make sure this is recompiled in production

window.Toolkit.Document.reloadImagePicker = ->
  $target = $("#image-picker .image-grid")

  if $target.attr("data-loaded") is "false"
    $.get("/images/choose", (data) ->
      $target.html(data)
      $target.attr("data-loaded", "true")
      window.Toolkit.Document.dropzone()
    ).fail((data) ->
      $("#image-picker .image-grid").html("There was a problem retrieving your images. Please try again.")
      $target.attr("data-loaded", "false")
    )
  else
    d = new Date()

    $.each($(".image-grid img"), (i, image) ->
      $(image).attr("src", "#{$(image).attr('src')}?#{d.getTime()}")
    )

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
    Toolkit.Document.contextualCrop = $(@).attr("data-crop") is "true"
    Toolkit.Document.cropOffset     = $(@).attr("data-crop-offset")

    Toolkit.Document.resizeWidth  = $(@).attr("data-resize-width")
    Toolkit.Document.resizeHeight = $(@).attr("data-resize-height")
    Toolkit.Document.papercrop    = window.Toolkit.Document.resizeWidth? and window.Toolkit.Document.resizeHeight?

    Toolkit.Document.reloadImagePicker()
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
    $target     = $("##{$("#image-picker").attr("data-target")}")           # The field where the value is set
    value       = $("#image-picker").find("figure.enabled img").attr("src") # The value to set on the field
    dataTarget  = $("#image-picker").attr("data-target")                    #
    $figure     = $("label[for='#{dataTarget}'] figure")                    #
    $positioner = $figure.find(".positioner")                               # The container for the text that launched the modal
    
    # Assign the value to the input
    $target.val(value)
    $target.prop("checked", true)
    $target.trigger("change")

    # Display the selected image
    $figure.css({"background-image": "url('#{value}'"}).addClass("image-added")
    $positioner.html("<span class='icons'>C</span>Change Image")

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
  $.each(Toolkit.Document.savedData, (key, data) ->
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
            $figure     = $("label[for='#{data.fieldID}'] figure")
            $positioner = $figure.find(".positioner")

            # Set the value
            $field.val(data.value)

            # Display the selected image
            $figure.css({"background-image": "url('#{data.value}'"}).addClass("image-added")
            $positioner.html("<span class='icons'>C</span>Change Image")
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
  if Toolkit.init.documentDataTarget is false
    Toolkit.init.documentDataTarget = true

    $(document).on("change", "[data-target]", ->
      $target = $("##{$(@).attr('data-target')}")
      $target.val($(@).val())
    )

window.Toolkit.Document.dropzone = ->
  $form = $("form[data-document='true']")
  Toolkit.dropzones = []

  if $("#upload-photo-form").length isnt 0
    try
      Toolkit.dropzones.push(
        # Initialize Dropzone
        $("#upload-photo-form").dropzone({
          paramName: "image[image]",
          url: "/images",
          dictDefaultMessage: "<h4>DROP IMAGE HERE TO UPLOAD</h4><p class='or'>or</p><div class='button'>Select File</div>",
          
          sending: ((file, xhr, formData) ->
            $("#image-picker .upload-image, #image-picker .select-image, #image-picker #image-error").hide( ->
              $("#image-picker #loading").show()
            )
          )

          # Callback when the image cannot be uploaded
          error: ((file, message, xhr) ->
            # console.log(file)
            # console.log(message)
            # console.log(xhr)
            @.removeFile(file)
            $("#image-picker #loading").hide( ->
              $("#image-error").html(xhr.responseText).show()
              $("#image-picker .upload-image, #image-picker .select-image").show()
            )
            
          ),
          
          # Callback when the image is uploaded
          success: ((file, data) ->
            $(document).on("submit", ".edit_image", ->
              $(".edit_image").hide( ->
                $("#image-picker #loading").show()
              )
            )

            # Contextual Crop is enabled for this image field
            if $form.attr("data-crop-enabled") is "true" and Toolkit.Document.contextualCrop
              $("#image-picker .choose-crop").hide()
              # Get the image crop form
              $.get("/images/#{data.id}/contextual_crop?image[template_id]=#{$form.attr("data-template-id")}&image[strategy]=contextual_crop", (data) =>
                @.removeFile(file)

                $("#image-picker #loading").hide( ->
                  $("#image-picker .crop-image").html(data).show(->
                    $(".drag").draggable({
                      stop: (event, ui) ->
                        position = $(".drag").position()
                        $("#image_pos_x").val(position.left)
                        $("#image_pos_y").val(position.top - Toolkit.Document.cropOffset)
                    })
                  )
                  
                  $(".edit_image").on("ajax:success", (e, data, status, xhr) ->
                    e.preventDefault()

                    # Clear out this image's data in case the user wants to crop another image
                    $("#image-picker .crop-image").html("")
                    
                    $("#image-picker #loading").hide(->
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
                      Toolkit.Document.reloadImagePicker()

                      # Remove the event listener so it doesn't fire multuple times
                      $(".edit_image").off("ajax:success")
                    )

                  # When the image cannot be cropped
                  ).on("ajax:error", (e, xhr, status, error) ->
                    $("#image-error").html("There was an error cropping your image. Please try again.")
                  )
                )
              )

            # Default Crop is enabled for this image field
            else if Toolkit.Document.papercrop?
              $("#image-picker .choose-crop").hide()
              
              # Get the image crop form
              $.get("/images/#{data.id}/papercrop?image[resize_height]=#{Toolkit.Document.resizeHeight}&image[resize_width]=#{Toolkit.Document.resizeWidth}&image[strategy]=papercrop", (data) =>
                @.removeFile(file)

                $("#image-picker #loading").hide( ->
                  $("#image-picker .crop-image").html(data).show(->
                    $(".drag").draggable({
                      stop: (event, ui) ->
                        position = $(".drag").position()
                        $("#image_pos_x").val(position.left)
                        $("#image_pos_y").val(position.top - Toolkit.Document.cropOffset)
                    })
                  )

                  $(".edit_image").on("ajax:success", (e, data, status, xhr) ->
                    e.preventDefault()

                    # Clear out this image's data in case the user wants to crop another image
                    $("#image-picker .crop-image").html("")
                    
                    $("#image-picker #loading").hide(->
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
                      Toolkit.Document.reloadImagePicker()

                      # Remove the event listener so it doesn't fire multuple times
                      $(".edit_image").off("ajax:success")
                    )

                  # When the image cannot be cropped
                  ).on("ajax:error", (e, xhr, status, error) ->
                    $("#image-error").html("There was an error cropping your image. Please try again.")
                  )
                )
              )

            # Cropping is not enabled in this modal. Show the image grid.
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
    Toolkit.Document.addImage()
    Toolkit.Document.saveButton()
    Toolkit.optionsMenu()
    Toolkit.Document.saveIds()
    Toolkit.Document.fillForm()
    Toolkit.Document.dataTarget()

$(document).on('turbolinks:load', window.Toolkit.Document.ready)
