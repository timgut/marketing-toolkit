class Template < ApplicationRecord
  include Status

  has_many :flyers

  validates_presence_of :title, :description, :height, :width, :pdf_markup, :form_markup, :status
  validates_numericality_of :height, :width
end
