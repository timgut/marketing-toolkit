class Campaign < ApplicationRecord
  include Status

  has_and_belongs_to_many :documents

  has_many :templates

  validates_presence_of :title

  scope :active, -> { where(status: 1) }

end
