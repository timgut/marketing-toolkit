window.Toolkit ||= {}
window.Toolkit.Flyer ||= {}

# TODO: Remove surrounding quotes if user added them to the string.
window.Toolkit.normalizeQuotes = (str) ->
  str.replace(/[\u2018\u2019]/g, "'").replace(/[\u201C\u201D]/g, '"')

window.Toolkit.Flyer.addImage = ->
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
    # Assign the value to the input
    $target = $("##{$("#image-picker").attr("data-target")}")
    value = $("#image-picker").find("figure.enabled img").attr("src")
    $target.val(value)
    $target.prop("checked", true)

    # Replace the background image
    $label = $("label[for='#{$("#image-picker").attr("data-target")}']")
    height = $target.find("a").attr("height")
    width = $target.find("a").attr("width")
    $label.find(".positioner").hide()
    $label.find("a").append("<img src='#{value}' />")

    # Clean up
    $("#image-picker").popup("hide")
    $("#image-picker").removeAttr("data-target")
    $("#image-picker").find("figure.enabled").removeClass("enabled")
  )

  # Let the modal know which input to apply the selection to
  $(".image-picker").click( ->
    $("#image-picker").attr("data-target", $(@).attr("data-target"))
  )

window.Toolkit.Flyer.saveButton = ->
  $("[data-save='true']").click( ->
    $("input[name='generate']").val("false")
    $("form[data-flyer='true']").submit()
  )

window.Toolkit.Flyer.optionsMenu = ->
  $(document).on("click", ".options a", ->
    $menu = $(@).next("ol")

    if $menu.css("visibility") is "hidden"
      $menu.css({visibility: "visible", opacity: 1})
    else
      $menu.css({visibility: "hidden", opacity: 0})
  )

window.Toolkit.Flyer.fillForm = ->
  $.each(window.Toolkit.Flyer.savedData, (key, data) ->
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
            console.log("Filling in image field")
          else
            console.log("Don't know how to fill in #{$field.attr("data-custom")}")
  )

window.Toolkit.Flyer.saveIds = ->
  $("form[data-flyer='true']").on("change", "[data-persist-id]", ->
    # console.log("Changed #{$(@).attr('name')}")
    $target = $("[name='#{$(@).attr("data-persist-id")}']")
    value = $(@).attr("id")
    $target.val(value)
    # console.log("Set #{$(@).attr("data-persist-id")} to #{value}")
  )

window.Toolkit.Flyer.ready = ->
  window.Toolkit.Flyer.addImage()
  window.Toolkit.Flyer.saveButton()
  window.Toolkit.Flyer.optionsMenu()
  window.Toolkit.Flyer.saveIds()
  window.Toolkit.Flyer.fillForm()

$(document).on('turbolinks:load', window.Toolkit.Flyer.ready)