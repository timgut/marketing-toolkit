class Datum < ApplicationRecord
  belongs_to :document

  has_many :debuggers

  validates_presence_of :document, :key
end
