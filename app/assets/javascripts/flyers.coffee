window.Toolkit ||= {}

window.Toolkit.normalizeQuotes = (str) ->
  str.replace(/[\u2018\u2019]/g, "'").replace(/[\u201C\u201D]/g, '"')

window.Toolkit.previewImage = (element) ->
  console.log "Do something to preview image in #{$(element)}"

window.Toolkit.addImage = ->
  $(".image-picker").addClass("image-picker_open")
  
  $('#add_image_button').attr('disabled','disabled').addClass('disabled')
    
  $('.image-grid > figure').click( ->
    $(@).addClass('enabled')
    $(@).siblings().each( ->
      $(@).removeClass('enabled')
    )

    $('#add_image_button').removeAttr('disabled').removeClass('disabled')
  )

window.Toolkit.initFancybox = ->
  if $("a.fancybox").length > 0
    $("a.fancybox").fancybox()

window.Toolkit.flyerReady = ->
  window.Toolkit.addImage()
  window.Toolkit.initFancybox()

$(document).on('turbolinks:load', window.Toolkit.flyerReady)