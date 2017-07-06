window.Toolkit ||= {}

# Turbolinks will persist Javascript state across pages. If you do not
# want to initialize code more than once, use the init object to make
# sure that code is only loaded once.
window.Toolkit.init ||= {}

window.Toolkit.init.optionsMenu        = false
window.Toolkit.init.documentDataTarget = false

# Uncomment to add UI feedback from a delayed job
#
window.Toolkit.init.delayedJob = ->
  window.Toolkit.jobs = []

  $(document).on("click", "a[data-job]", (e, data, status, xhr) ->
    # $el = $(e.currentTarget)
    # console.log(e)
    # console.log(data)
    # console.log(status)
    # console.log(xhr)

    job = $(@).attr("data-job")
    id  = $(@).attr("id")

    switch job
      when "generateThumbnail"
        # Do something after the thumbnail has been generated
      else
        console.log("Unknown job: #{job}")
  )

Dropzone.autoDiscover = false

window.Toolkit.isEditPage = ->
  location.href.indexOf("edit") isnt -1

window.Toolkit.isDocumentPage = ->
  location.href.indexOf("/documents") isnt -1

window.Toolkit.resetDropzones = ->
  window.Toolkit.dropzones = []

window.Toolkit.mobileMenu = ->
  $(document).on("click", ".menu-trigger", ->
    $(".mobile.menu.main").slideToggle()
    
    if $(".mobile.menu.user").is(":visible")
      $(".mobile.menu.user").slideToggle()
      $("body").toggleClass("expanded-user-menu")

    $("body").toggleClass("expanded-menu")
  )

  $(document).on("click", ".user-trigger", ->
    $(".mobile.menu.user").slideToggle()

    if $(".mobile.menu.main").is(":visible")
      $(".mobile.menu.main").slideToggle()
      $("body").toggleClass("expanded-menu")

    $("body").toggleClass("expanded-user-menu")
  )

window.Toolkit.optionsMenu = ->
  if window.Toolkit.init.optionsMenu is false
    window.Toolkit.init.optionsMenu = true

    $(document).on("click", ".options a", ->
      $menu = $(@).next("ol")

      if $menu.css("visibility") is "hidden"
        $menu.css({visibility: "visible", opacity: 1})
      else
        $menu.css({visibility: "hidden", opacity: 0})
    )

# TODO: Remove surrounding quotes if user added them to the string.
window.Toolkit.normalizeQuotes = (str) ->
  str.replace(/[\u2018\u2019]/g, "'").replace(/[\u201C\u201D]/g, '"')

window.Toolkit.cleanup = ->
  window.Toolkit.Document.savedData = {}

window.Toolkit.mobileMenu()

$(document).on('turbolinks:click', window.Toolkit.cleanup)
