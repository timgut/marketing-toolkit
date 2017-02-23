class ImageUser < ApplicationRecord
  self.table_name = :images_users

  belongs_to :image
  belongs_to :user
  belongs_to :creator, class_name: "User", foreign_key: :creator_id
end
