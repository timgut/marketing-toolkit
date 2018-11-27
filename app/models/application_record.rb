class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  protected

  def s3_credentials
    {
      s3_region:        "us-east-1",
      bucket:           "toolkit.afscme.org",
      access_key_id:     Rails.application.secrets.aws[:access_key_id],
      secret_access_key: Rails.application.secrets.aws[:secret_access_key]
    }
  end
end
