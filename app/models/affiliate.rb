class Affiliate < ApplicationRecord
  has_many :users
  validates_presence_of :title, :region, :state, :slug
end
