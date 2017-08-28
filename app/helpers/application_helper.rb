module ApplicationHelper
  def changed_document_message
    "If you have made changes to this document, you must save it to see the changes."
  end

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

  def check_crop_marks?
    if @document.new_record?
      @template.crop_marks == 'true_by_default' ? true : false
    else
      @document.crop_marks
    end
  end
end
