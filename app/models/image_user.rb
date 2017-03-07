class ImageUser < ApplicationRecord
  self.table_name = :images_users

  belongs_to :image
  belongs_to :user
end
