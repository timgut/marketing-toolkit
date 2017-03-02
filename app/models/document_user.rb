class FlyerUser < ApplicationRecord
  self.table_name = :documents_users

  belongs_to :document
  belongs_to :user
end
