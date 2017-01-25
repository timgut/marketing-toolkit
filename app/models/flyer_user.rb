class FlyerUser < ApplicationRecord
  self.table_name = :flyers_users

  belongs_to :flyer
  belongs_to :user
end
