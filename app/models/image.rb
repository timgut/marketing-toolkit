class Image < ApplicationRecord
  has_attached_file :image, storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  validates_uniqueness_of :image_file_name, scope: :folder_id

  has_and_belongs_to_many :users

  has_many :images_users, class_name: "ImageUser"

  belongs_to :folder

  # Unsure right now if this should be a method or association. This returns the User record for the creator.
  def creator
    images_users.where(user_id: User.current_user.id).first.creator
  end

  protected

  def s3_credentials
    {
      s3_region:        "us-east-1",
      bucket:           "toolkit.afscme.org",
      path:              "/#{Rails.application.secrets.aws["folder"]}/images/:path",
      access_key_id:     Rails.application.secrets.aws["access_key_id"],
      secret_access_key: Rails.application.secrets.aws["secret_access_key"]
    }
  end
end
