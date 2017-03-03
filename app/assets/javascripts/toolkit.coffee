window.Toolkit ||= {}

# Turbolinks will persist Javascript state across pages. If you do not
# want to initialize code more than once, use the init object to make
# sure that code is only loaded once.
window.Toolkit.init ||= {}
window.Toolkit.init.optionsMenu = false

window.Toolkit.optionsMenu = ->
  if window.Toolkit.init.optionsMenu is false
    window.Toolkit.init.optionsMenu = true

    $(document).on("click", ".options a", ->
      $menu = $(@).next("ol")
      console.log($menu)
      if $menu.css("visibility") is "hidden"
        $menu.css({visibility: "visible", opacity: 1})
      else
        $menu.css({visibility: "hidden", opacity: 0})
    )
