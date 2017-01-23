class Datum < ApplicationRecord
  belongs_to :flyer

  validates_presence_of :flyer, :key, :value
end
