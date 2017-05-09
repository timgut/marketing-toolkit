class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def dimensions(attachment, style=:original)
    @dimensions ||= {}
    name = "#{attachment}-#{style}"
    
    if @dimensions[name].nil?
      geometry = Paperclip::Geometry.from_file(__send__(attachment).url(style))
      @dimensions[name] = {width: geometry.width.to_i, height: geometry.height.to_i}
    end

    @dimensions[name]
  end

  protected

  def s3_credentials
    {
      s3_region:        "us-east-1",
      bucket:           "toolkit.afscme.org",
      access_key_id:     Rails.application.secrets.aws["access_key_id"],
      secret_access_key: Rails.application.secrets.aws["secret_access_key"]
    }
  end
end
