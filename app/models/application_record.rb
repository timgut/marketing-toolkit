class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  ###
  # Determines where an image should be placed in S3 depending on the model.
  # @param {string} filename - The name of the file; the part after the final forward slash.
  # @param {integer} user_id - For models that don't belong to a user, pass in the ID of the user who should own the image.
  # @return {string} The path to place the image in the S3 bucket.
  def s3_path(filename:, user_id: nil)
    if user_id != nil
      self.creator = User.find(user_id)
    end

    if self.is_a?(Image)
      folder  = "#{self.creator.id}_#{self.creator.last_name.downcase.gsub(' ','-')}_#{self.creator.first_name.downcase.gsub(' ','-')}/images"
    elsif self.is_a?(StockImage)
      folder  = "#{self.creator.id}_#{self.creator.last_name.downcase.gsub(' ','-')}_#{self.creator.first_name.downcase.gsub(' ','-')}/images"
    elsif self.is_a?(Document)
      folder  = "#{self.creator.id}_#{self.creator.last_name.downcase.gsub(' ','-')}_#{self.creator.first_name.downcase.gsub(' ','-')}/documents"
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
