module ApplicationHelper
  def changed_document_message
    "If you have made changes to this document, you must save it to see the changes."
  end

  def dimensions(template)
    "#{template.width}\" x #{template.height}\""
  end

  def thumbnail_url(document)
    if document.thumbnail_file_name
      document.thumbnail.url
    else
      document.template.thumbnail.url
    end
  end
end
