class Template < ApplicationRecord
  include Status

  has_many :documents

  belongs_to :campaign, optional: true
  belongs_to :category, optional: true

  validates :title, :description, :height, :width, :pdf_markup, :form_markup, :status, presence: true, if: Proc.new{|t| t.customize?}
  validates :height, :width, numericality: true, if: Proc.new{|t| t.customize?}

  scope :with_category, ->(category_id){ where(category_id: category_id) }

  has_attached_file :thumbnail,      storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  has_attached_file :numbered_image, storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  has_attached_file :blank_image,    storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  has_attached_file :static_pdf,     storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }

  validates_attachment_content_type :thumbnail,      content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :numbered_image, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :blank_image,    content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :static_pdf,     content_type: "application/pdf"

  def croppable?
    blank_image.exists?
  end
end
