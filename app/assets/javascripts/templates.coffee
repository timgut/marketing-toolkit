window.Toolkit ||= {}
window.Toolkit.Template ||= {}

window.Toolkit.Template.optionsMenu = ->
  $(document).on("click", ".options a", ->
    $menu = $(@).next("ol")

    if $menu.css("visibility") is "hidden"
      $menu.css({visibility: "visible", opacity: 1})
    else
      $menu.css({visibility: "hidden", opacity: 0})
  )

window.Toolkit.Template.codeMirror = ->
  codeMirrorOpts = {
    lineNumbers: true,
    mode:        "css",
    theme:       "ambiance",
    tabSize:     2
  }

  if pdfTextarea = document.getElementById("template_pdf_markup")
    window.Toolkit.pdfEditor = CodeMirror.fromTextArea(pdfTextarea, codeMirrorOpts)

  if formTextarea = document.getElementById("template_form_markup")
    window.Toolkit.formEditor = CodeMirror.fromTextArea(formTextarea, codeMirrorOpts)

  if optionsTextarea = document.getElementById("template_customizable_options")
    window.Toolkit.optionsEditor = CodeMirror.fromTextArea(optionsTextarea, codeMirrorOpts)

window.Toolkit.Template.dropzone = ->
  $("[data-dropzone='true']").find("input[type='file']").dropzone({ url: $("[data-dropzone='true']").attr("action") })

window.Toolkit.Template.ready = ->
  window.Toolkit.Template.optionsMenu()
  window.Toolkit.Template.codeMirror()
  window.Toolkit.Template.dropzone()

$(document).on('turbolinks:load', window.Toolkit.Template.ready)
