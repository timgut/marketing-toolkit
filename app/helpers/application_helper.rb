module ApplicationHelper
  def dimensions(template)
    "#{template.width}\" x #{template.height}\""
  end

  def download_link(document)
    if document.pdf_file_name
      document.pdf.url
    else
      download_document_path(document)
    end
  end

  def thumbnail_url(document)
    if document.thumbnail_file_name
      document.thumbnail.url
    else
      document.template.thumbnail.url
    end
  end
end
