class Template < ApplicationRecord
  include Status

  ATTACHMENTS = [:thumbnail, :numbered_image, :blank_image, :static_pdf]

  belongs_to :campaign

  has_many :documents

  belongs_to :campaign, optional: true
  belongs_to :category, optional: true

  validates :title, :description, :height, :width, :pdf_markup, :form_markup, :status, presence: true, if: Proc.new{|t| t.customize?}
  validates :height, :width, numericality: true, if: Proc.new{|t| t.customize?}

  scope :with_category, ->(category_id){ where(category_id: category_id) }

  ATTACHMENTS.each do |attachment|
    has_attached_file attachment, storage: :s3, s3_protocol: "https",  s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  end

  validates_attachment_content_type :thumbnail,      content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :numbered_image, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :blank_image,    content_type: /\Aimage\/.*\z/

  def croppable?
    blank_image.exists?
  end
end
