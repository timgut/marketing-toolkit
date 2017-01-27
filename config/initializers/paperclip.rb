require 'paperclip/media_type_spoof_detector'

module Paperclip
  class MediaTypeSpoofDetector
    # PDFs from strings won't have a valid content type and will raise an error.
    # Overwriting this method to return false will fix this.
    def spoofed?
      false
    end
  end
end

Paperclip::Attachment.default_options[:use_timestamp] = false

Paperclip.interpolates :dynamic_path do |attachment, style|
  if attachment.instance.is_a?(Image)
    file_type = "images"
    file_name = attachment.instance.image_file_name
  elsif attachment.instance.is_a?(Flyer)
    file_type = "flyers"
    file_name = attachment.instance.pdf_file_name
  end

  path   = attachment.instance.folder.path
  folder = attachment.instance.folder.path == "/" ? "root" : attachment.instance.folder.path
  
  
  "/#{Rails.application.secrets.aws["folder"]}/#{file_type}/#{folder}/#{style}/#{file_name}".gsub("//", "/")
end
