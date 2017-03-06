window.Toolkit ||= {}
window.Toolkit.Document ||= {}

# TODO: Remove surrounding quotes if user added them to the string.
window.Toolkit.normalizeQuotes = (str) ->
  str.replace(/[\u2018\u2019]/g, "'").replace(/[\u201C\u201D]/g, '"')

window.Toolkit.Document.addImage = ->
  # Init image picker
  $(".image-picker").addClass("image-picker_open")
  
  $("#image-picker").popup({
    opacity: '0.8',
    color: 'black'
  })

  $('#add_image_button').attr('disabled','disabled').addClass('disabled')
  
  # Stylize only the selected image
  $('.image-grid > figure').click( ->
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
    $("input[name='generate']").val("false")
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
            $customField = $("##{data.fieldID}-custom")
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
    # console.log("Changed #{$(@).attr('name')}")
    $target = $("[name='#{$(@).attr("data-persist-id")}']")
    value = $(@).attr("id")
    $target.val(value)
    # console.log("Set #{$(@).attr("data-persist-id")} to #{value}")
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

window.Toolkit.Document.ready = ->
  window.Toolkit.Document.addImage()
  window.Toolkit.Document.saveButton()
  window.Toolkit.optionsMenu()
  window.Toolkit.Document.saveIds()
  window.Toolkit.Document.fillForm()
  window.Toolkit.Document.disableDownloadButton()

$(document).on('turbolinks:load', window.Toolkit.Document.ready)
