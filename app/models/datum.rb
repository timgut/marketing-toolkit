class Datum < ApplicationRecord
  belongs_to :flyer

  # Not validating :data yet. We don't care what the data is; we only care that the key exists.
  validates_presence_of :flyer, :key
end
