class Template < ApplicationRecord
  include Status

  ATTACHMENTS = [:thumbnail, :numbered_image, :blank_image, :static_pdf]

  belongs_to :campaign

  has_many :documents
  belongs_to :category

  validates :title, :description, :height, :width, :pdf_markup, :form_markup, :status, presence: true, if: Proc.new{|template| template.customize == true}
  validates :height, :width, numericality: true, if: Proc.new{|template| template.customize?}

  scope :with_category, ->(category_id){ where(category_id: category_id) }

  ATTACHMENTS.each do |attachment|
    has_attached_file attachment, storage: :s3, s3_protocol: "https",  s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  end
end
