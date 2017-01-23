class Campaign < ApplicationRecord
  include Status

  has_and_belongs_to_many :flyers

  validates_presence_of :title, :description, :status
end
