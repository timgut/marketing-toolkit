class Campaign < ApplicationRecord
  has_and_belongs_to_many :flyers
end
