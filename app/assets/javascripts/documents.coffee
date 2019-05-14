window.Toolkit ||= {}
window.Toolkit.Document ||= {}

window.Toolkit.Document.reloadImagePicker = ->
  $target = $("#image-picker .image-grid")
  Toolkit.Document.croppingStockPhoto = false

  if $target.attr("data-loaded") is "false"
    $.get("/images/choose", (data) ->
      $target.html(data)
      $target.attr("data-loaded", "true")
      window.Toolkit.Document.dropzone()

      # Only allow stock images to be cropped if cropping is enabled on this photo
      if Toolkit.Document.papercrop isnt true
        $("[data-role='crop-image']").hide()
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

  $("[data-role='add-image']").attr('disabled','disabled').addClass('disabled')
  
  # Get images and populate .image-grid
  $(document).on("click", ".image-picker", ->
    Toolkit.Document.contextualCrop = $(@).attr("data-crop") is "true"
    Toolkit.Document.cropOffset     = $(@).attr("data-crop-offset")

    Toolkit.Document.resizeWidth  = $(@).attr("data-resize-width")
    Toolkit.Document.resizeHeight = $(@).attr("data-resize-height")
    Toolkit.Document.papercrop    = window.Toolkit.Document.resizeWidth? and window.Toolkit.Document.resizeHeight?

    Toolkit.Document.reloadImagePicker()
  )

  # Mark the image gallery to be reloaded, as another modal may have cropping enabled.
  $(document).on("click", ".image-picker_close", ->
    $("#image-picker .image-grid").attr("data-loaded", "false")
  )

  # Stylize only the selected image
  $(document).on("click", "[role='tabpanel'] figure", ->
    $("figure.enabled").removeClass('enabled')
    $(@).addClass('enabled')
    $("[data-role='add-image']").removeAttr('disabled')

    if $(@).attr("data-stock") is "true"
      $("[data-role='crop-image']").removeAttr("disabled")
  )

  # Crop the selected stock photo
  $(document).on("click", "[data-role='crop-image']", ->
    data = {
      id: $("#stock .gallery figure.enabled").attr("data-id")
    }

    Toolkit.Document.croppingStockPhoto = true
    endpoint = endpoint = "/images/#{data.id}/papercrop?image[resize_height]=#{Toolkit.Document.resizeHeight}&image[resize_width]=#{Toolkit.Document.resizeWidth}&image[strategy]=papercrop&stock_photo=true"
    window.Toolkit.Document.cropPhoto(endpoint, data)
  )

  # Show loading div when submitting the jCrop form
  $(document).on("submit", ".edit_image", ->
    $(".edit_image").hide( ->
      $("#image-picker #loading").show()
    )
  )

  # Close the modal and assign the selected image to the target input
  $(document).on("click", "[data-role='add-image']", ->
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
    $positioner.html("
      <div class='controls'>
        <div class='change'>
          <svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1024 1024'><path d='M245.4,937.5l61.5-61.5L148,717.1l-61.5,61.5V851H173v86.5H245.4z M598.9,310.2c0-9.9-5-14.9-14.9-14.9 c-4.5,0-8.3,1.6-11.5,4.7L206.2,666.4c-3.2,3.2-4.7,7-4.7,11.5c0,9.9,5,14.9,14.9,14.9c4.5,0,8.3-1.6,11.5-4.7l366.3-366.3    C597.3,318.6,598.9,314.7,598.9,310.2z M562.4,180.5l281.2,281.2L281.2,1024H0V742.8L562.4,180.5z M1024,245.4 c0,23.9-8.3,44.2-25,60.8L886.8,418.4L605.6,137.2L717.8,25.7C734,8.6,754.3,0,778.6,0c23.9,0,44.4,8.6,61.5,25.7L999,183.8C1015.7,201.4,1024,221.9,1024,245.4z'/></svg>
        </div>
        <div class='delete'>
          <svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 1024 1024'><path d='M696,512l312.7,312.7c20.3,20.3,20.3,53.3,0,73.6l-110.4,110.4c-20.3,20.3-53.3,20.3-73.6,0L512,696l-312.8,312.7 c-20.3,20.3-53.3,20.3-73.6,0L15.2,898.4c-20.3-20.3-20.3-53.3,0-73.6L328,512L15.2,199.2c-20.3-20.3-20.3-53.3,0-73.6L125.7,15.2c20.3-20.3,53.3-20.3,73.6,0L512,328L824.8,15.2c20.3-20.3,53.3-20.3,73.6,0l110.4,110.4c20.3,20.3,20.3,53.3,0,73.6L696,512 L696,512z'/></svg>
        </div>
      </div>
    ")

    # Clean up the modal div
    $("#image-picker").popup("hide")
    $("#image-picker").removeAttr("data-target")
    $("#image-picker").find("figure.enabled").removeClass("enabled")
    $("[data-role='add-image']").attr("disabled", "disabled")
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

window.Toolkit.Document.fillWysiwyg = (editor) ->
  if Toolkit.Document.hasOwnProperty("savedData")
    id = editor.id.split("-custom")[0]

    if Toolkit.Document.savedData[id]
      editor.setContent(Toolkit.Document.savedData[id].value)
    else
      console.log "[wysiwyg] Cannot find savedData for #{id}"

# Put the savedData values in the correct fields.
window.Toolkit.Document.fillForm = ->
  $.each(Toolkit.Document.savedData, (key, data) ->
    if data.fieldID
      # Assign the saved value to the field, and persist the field ID and value with the change() event.
      $field = $("##{data.fieldID}")
      $field.val(data.value)
      $field.change()

      switch $field.attr("type")
        when "hidden"
          $field.val(data.value)
        else
          $field.prop("checked", true)

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
          when "combine"
            $customFields = $("label[for='#{data.fieldID}']").find("[data-combine-tag]")

            # Put the custom text here so we can parse it with jQuery
            $("#custom-text").html(data.value)

            $.each($customFields, (i, field) ->
              # Use data-combine-tag to get the value for this field out of $value
              tag = $(field).attr("data-combine-tag")
              value = $("#custom-text").find(tag)
              $(field).val(value.text())
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
          when "wysiwyg"
            # See /documents/_form.html.erb and the fillWysiwyg(editor) function
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

# Sometimes we don't want to populate the value attribute because the text is too large.
# By adding a data-value attrbute to an input, you can give it an ID and it will fill in
# the input value with the html inside of the ID.
window.Toolkit.Document.fillValues = ->
  $form  = $("form[data-document='true']")
  $pulls = $("[data-value]")

  $.each($pulls, (i, input) ->
    $(input).val($("##{$(input).attr("data-value")}").html())
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
          autoProcessQueue: true,
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
            @.removeFile(file)

            # Contextual Crop is enabled for this image field
            if $form.attr("data-crop-enabled") is "true" and Toolkit.Document.contextualCrop
              $("#image-picker .choose-crop").hide()
              endpoint = "/images/#{data.id}/contextual_crop?image[template_id]=#{$form.attr("data-template-id")}&image[strategy]=contextual_crop"
              Toolkit.Document.cropPhoto(endpoint, data)

            # Default Crop is enabled for this image field
            else if Toolkit.Document.papercrop isnt false
              endpoint = "/images/#{data.id}/papercrop?image[resize_height]=#{Toolkit.Document.resizeHeight}&image[resize_width]=#{Toolkit.Document.resizeWidth}&image[strategy]=papercrop"
              Toolkit.Document.cropPhoto(endpoint, data)

            # Cropping is not enabled in this modal. Show the image grid.
            else
              $("#image-picker .crop-image, #loading").hide( ->
                Toolkit.Document.addToGallery(data)
              )
          )
        });
      )
    catch
      # Dropzone will throw an error if it's being initialized multiple times.
      # This shouldn't cause a problem, but you never know.
      # console.log "Dropzone already attached"

window.Toolkit.Document.cropPhoto = (endpoint, data) ->
  $("#image-picker .select-image").hide( ->
    $("#image-picker #loading").show()
  )

  Toolkit.Document.croppingStockPhoto = false # Reset this immediately, as we don't need it anymore
  $("[data-role='crop-image']").attr("disabled", "disabled")

  # Get the image crop form
  $.get(endpoint, (html) =>
    $("#image-picker #loading").hide( ->
      $("#image-picker .crop-image").html(html).show(->
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

        Toolkit.Document.addToGallery(data)
        $("#mine button.save").trigger("click")

      # When the image cannot be cropped
      ).on("ajax:error", (e, xhr, status, error) ->
        $("#image-error").html("There was an error cropping your image. Please try again.")
      )
    )
  )

# After an image has been uploaoded or cropped, i's added to the gallery and selected.
window.Toolkit.Document.addToGallery = (data) ->
  # Add the image to 'My Photos' and select it
  $("#image-picker .crop-image").hide( ->
    $("#image-picker #mine .gallery").append("
      <figure>
        <img src='#{data.cropped_url}' alt='#{data.file_name}' />
        <figcaption>#{data.file_name}</figcaption>
      </figure>
    ")

    $("#image-picker #mine .gallery figure:last").click()
    Toolkit.Document.reloadImagePicker()
    $("#image-picker .select-image").show()

    # Remove the event listener so it doesn't fire multuple times
    $(".edit_image").off("ajax:success")

    # Show the 'My Photos' tab
    $("#tabs").tabs("option", "active", 1)
  )

window.Toolkit.Document.ready = ->
  if window.Toolkit.isDocumentPage()
    Toolkit.Document.addImage()
    Toolkit.Document.saveButton()
    Toolkit.optionsMenu()
    Toolkit.Document.saveIds()
    Toolkit.Document.fillForm()
    Toolkit.Document.fillValues()
    Toolkit.Document.dataTarget()

$(document).on('turbolinks:load', window.Toolkit.Document.ready)
