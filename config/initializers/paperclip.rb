require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end

Paperclip::Attachment.default_options[:use_timestamp] = false

Paperclip.interpolates :path do |attachment, style|
  attachment.instance.folder.path
end

Paperclip.interpolates :dynamic_path do |attachment, style|
  path = attachment.instance.folder.path
  file_name = attachment.instance.image_file_name
  folder = attachment.instance.folder.path == '/' ? "root" : attachment.instance.folder.path
  "/images/#{folder}/#{style}/#{file_name}"
end
