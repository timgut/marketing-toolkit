class DocumentUser < ApplicationRecord
  self.table_name = :documents_users

  belongs_to :document
  belongs_to :user
  belongs_to :creator, class_name: "User", foreign_key: :creator_id
end
