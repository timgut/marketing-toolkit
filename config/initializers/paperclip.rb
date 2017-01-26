Paperclip.interpolates :dynamic_path do |attachment, style|
  path = attachment.instance.folder.path
  file_name = attachment.instance.image_file_name
  folder = attachment.instance.folder.path == '/' ? "root" : attachment.instance.folder.path
  "/images/#{folder}/#{style}/#{file_name}"
end
