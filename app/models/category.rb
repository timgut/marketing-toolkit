class Category < ApplicationRecord
 	has_many :templates
  validates_presence_of :title
end