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

    "/#{Rails.application.secrets.aws[:folder]}/#{folder}//#{filename}".gsub("//", "/")
  end
end
