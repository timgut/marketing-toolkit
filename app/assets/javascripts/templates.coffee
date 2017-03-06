window.Toolkit ||= {}
window.Toolkit.Template ||= {}

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

window.Toolkit.Template.dropzones = ->
  window.Toolkit.resetDropzones()

  if $("#template-thumbnail-form").length isnt 0
    window.Toolkit.dropzones.push(
      $("#template-thumbnail-form").dropzone({
        paramName: "template[thumbnail]",
        url: $("#template-thumbnail-form").attr("action")
      });
    )

  if $("#template-numbered-form").length isnt 0
    window.Toolkit.dropzones.push(
      $("#template-numbered-form").dropzone({
        paramName: "template[numbered_image]",
        url: $("#template-numbered-form").attr("action")
      });
    )

  if $("#template-blank-form").length isnt 0
    window.Toolkit.dropzones.push(
      $("#template-blank-form").dropzone({
        paramName: "template[blank_image]",
        url: $("#template-blank-form").attr("action")
      });
    )

window.Toolkit.Template.ready = ->
  window.Toolkit.optionsMenu()
  window.Toolkit.Template.codeMirror()
  window.Toolkit.Template.dropzones()

$(document).on('turbolinks:load', window.Toolkit.Template.ready)
