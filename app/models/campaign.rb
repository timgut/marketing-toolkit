class Campaign < ApplicationRecord
  include Status

  has_and_belongs_to_many :flyers

  has_many :templates

  validates_presence_of :title, :description, :status
end
