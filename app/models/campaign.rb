class Campaign < ApplicationRecord
  include Status
  include Tree

  has_many :templates

  validates_presence_of :title
end
