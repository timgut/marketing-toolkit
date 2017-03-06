window.Toolkit ||= {}

# Turbolinks will persist Javascript state across pages. If you do not
# want to initialize code more than once, use the init object to make
# sure that code is only loaded once.
window.Toolkit.init ||= {}
window.Toolkit.init.optionsMenu = false

Dropzone.autoDiscover = false

window.Toolkit.resetDropzones = ->
  window.Toolkit.dropzones = []

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