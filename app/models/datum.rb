class Datum < ApplicationRecord
  belongs_to :document

  validates_presence_of :document, :key
end
