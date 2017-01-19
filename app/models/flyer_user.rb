class FlyerUser < ApplicationRecord
  belongs_to :flyer
  belongs_to :user
end
