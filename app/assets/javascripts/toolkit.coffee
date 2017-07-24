window.Toolkit ||= {}

# Turbolinks will persist Javascript state across pages. If you do not
# want to initialize code more than once, use the init object to make
# sure that code is only loaded once.
window.Toolkit.init ||= {}

Toolkit.init.optionsMenu        = false
Toolkit.init.documentDataTarget = false

Toolkit.init.jobs = ->
  window.Toolkit.jobs = []

  $(document).on("click", "a[data-job]", (e, data, status, xhr) ->
    $el = $(e.currentTarget).closest(".document")
    job = $(@).attr("data-job")
    id  = $(@).attr("data-id")

    switch job
      when "pdfAndThumbnail"
        new Toolkit.Job($el, job, id)
      else
        console.log "Unknown job: #{job}"
  )

Dropzone.autoDiscover = false

Toolkit.isEditPage = ->
  location.href.indexOf("edit") isnt -1

Toolkit.isDocumentPage = ->
  location.href.indexOf("/documents") isnt -1

Toolkit.resetDropzones = ->
  window.Toolkit.dropzones = []

Toolkit.mobileMenu = ->
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

Toolkit.optionsMenu = ->
  if Toolkit.init.optionsMenu is false
    window.Toolkit.init.optionsMenu = true

    $(document).on("click", ".options a", ->
      $menu = $(@).next("ol")

      if $menu.css("visibility") is "hidden"
        $menu.css({visibility: "visible", opacity: 1})
      else
        $menu.css({visibility: "hidden", opacity: 0})
    )

# TODO: Remove surrounding quotes if user added them to the string.
Toolkit.normalizeQuotes = (str) ->
  str.replace(/[\u2018\u2019]/g, "'").replace(/[\u201C\u201D]/g, '"')

Toolkit.cleanup = ->
  window.Toolkit.Document.savedData = {}

Toolkit.mobileMenu()
Toolkit.init.jobs()

$(document).on('turbolinks:click', Toolkit.cleanup)
