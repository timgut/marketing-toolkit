window.Toolkit ||= {}

# Turbolinks will persist Javascript state across pages. If you do not
# want to initialize code more than once, use the init object to make
# sure that code is only loaded once.
window.Toolkit.init ||= {}

window.Toolkit.init.optionsMenu        = false
window.Toolkit.init.documentDataTarget = false

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

window.Toolkit.loadingBox = ->
  "
    <div class='loading-box'>
      <div class='vert-align'>
        <div class='loader'>
          <svg version='1.1' id='loader-1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' x='0px' y='0px' width='40px' height='40px' viewBox='0 0 50 50' style='enable-background:new 0 0 50 50;' xml:space='preserve'>
            <path fill='#fff' d='M43.935,25.145c0-10.318-8.364-18.683-18.683-18.683c-10.318,0-18.683,8.365-18.683,18.683h4.068c0-8.071,6.543-14.615,14.615-14.615c8.072,0,14.615,6.543,14.615,14.615H43.935z'>
              <animateTransform
                attributeType='xml'
                attributeName='transform'
                type='rotate' 
                from='0 25 25' 
                to='360 25 25' 
                dur='0.6s' 
                repeatCount='indefinite' 
              />
            </path>
          </svg>
        </div>
        <div class='loading-text'>
          Loading Image
          <small>High Resolution images may take a moment</small>
        </div>
      </div>
    </div>
  "

window.Toolkit.mobileMenu()

$(document).on('turbolinks:click', window.Toolkit.cleanup)
