window.Toolkit ||= {}

window.Toolkit.normalizeQuotes = (str) ->
  str.replace(/[\u2018\u2019]/g, "'").replace(/[\u201C\u201D]/g, '"')

window.Toolkit.previewImage = (element) ->
  console.log "Do something to preview image in #{$(element)}"