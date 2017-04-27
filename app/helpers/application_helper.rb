module ApplicationHelper
  def dimensions(template)
    "#{template.width}\" x #{template.height}\""
  end

  ## touching this file

  def download_link(document)
    if document.pdf_file_name
      document.pdf.url
    else
      download_document_path(document)
    end
  end
end
