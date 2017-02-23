window.Toolkit ||= {}

window.Toolkit.templateReady = ->
  codeMirrorOpts = {
    lineNumbers: true,
    mode : "css",
    theme: "ambiance",
    tabSize: 2
  }

  if pdfTextarea = document.getElementById("template_pdf_markup")
    window.Toolkit.pdfEditor = CodeMirror.fromTextArea(pdfTextarea, codeMirrorOpts)

  if formTextarea = document.getElementById("template_form_markup")
    window.Toolkit.formEditor = CodeMirror.fromTextArea(formTextarea, codeMirrorOpts)

$(document).on('turbolinks:load', window.Toolkit.templateReady)
