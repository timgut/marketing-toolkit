class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def s3_path(filename:)
    if self.is_a?(Image)
      folder  = "#{creator.id}_#{creator.last_name.downcase.gsub(' ','-')}_#{creator.first_name.downcase.gsub(' ','-')}/images"
    elsif self.is_a?(Document)
      folder  = "#{creator.id}_#{creator.last_name.downcase.gsub(' ','-')}_#{creator.first_name.downcase.gsub(' ','-')}/documents"
    elsif self.is_a?(Template)
      folder = "templates/#{self.id}"
    else
      raise "#{self.class.to_s} does not implement #s3_path."
    end

    "#{Rails.application.secrets.aws[:folder]}/#{folder}/#{filename}"
  end

  ###
  # Uploads a file to S3.
  # @param {String} filepath - The path where the file is located
  ###
  def upload_to_s3!(filepath:)
    fullpath = s3_path(filename: filepath.split("/").last)
    service  = Aws::S3::Resource.new(region: "us-east-1", http_wire_trace: true)
    object   = service.bucket("toolkit.afscme.org").object(fullpath)
    
    object.upload_file(filepath, acl: "public-read")
  end
end
