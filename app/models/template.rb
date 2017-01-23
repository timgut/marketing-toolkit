class Template < ApplicationRecord
  has_many :fields
  has_many :flyers

  validates_presence_of :title, :description, :height, :width, :pdf_markup, :form_markup
  validates_numericality_of :height, :width
end
