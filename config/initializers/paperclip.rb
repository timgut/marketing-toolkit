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
  # TODO: DRY this up.
  if attachment.instance.is_a?(Image)
    file_type = "images"
    file_name = attachment.instance.image_file_name

    creator = attachment.instance.creator
    folder  = "#{creator.id}_#{creator.last_name.downcase.gsub(' ','-')}_#{creator.first_name.downcase.gsub(' ','-')}"
  elsif attachment.instance.is_a?(Document)
    file_type = "documents"
    file_name = attachment.instance.__send__("#{attachment.name.to_s}_file_name".to_sym)

    creator = attachment.instance.creator
    folder  = "#{creator.id}_#{creator.last_name.downcase.gsub(' ','-')}_#{creator.first_name.downcase.gsub(' ','-')}"
  elsif attachment.instance.is_a?(Template)
    extension = attachment.instance.__send__("#{attachment.name}_content_type".to_sym).split("/").last
    file_type = "templates/#{attachment.instance.id}"
    file_name = "#{attachment.name.to_s}.#{extension}"
  end

  "/#{Rails.application.secrets.aws[:folder]}/#{folder}/#{file_type}/#{style}/#{file_name}".gsub("//", "/")
end
