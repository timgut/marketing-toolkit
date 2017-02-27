window.Toolkit ||= {}

window.Toolkit.normalizeQuotes = (str) ->
  str.replace(/[\u2018\u2019]/g, "'").replace(/[\u201C\u201D]/g, '"')

window.Toolkit.addImage = ->
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

window.Toolkit.flyerReady = ->
  window.Toolkit.addImage()
  $("[data-save='true']").click( ->
    $("input[name='generate']").val("false")
    $("form[data-flyer='true']").submit()
  )

$(document).on('turbolinks:load', window.Toolkit.flyerReady)