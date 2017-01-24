class Image < ApplicationRecord
  has_attached_file :image
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  has_and_belongs_to_many :users

  belongs_to :folder
end
