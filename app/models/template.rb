class Template < ApplicationRecord
  include Status

  has_many :documents

  belongs_to :campaign
  belongs_to :category

  validates :title, :description, :height, :width, :pdf_markup, :form_markup, :status, presence: true, if: Proc.new{|template| template.customize == true}
  validates :height, :width, numericality: true, if: Proc.new{|template| template.customize?}

  before_save :set_blank_image_dimensions

  scope :with_category, ->(category_id){ where(category_id: category_id) }

  has_attached_file :thumbnail,      storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  has_attached_file :numbered_image, storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  has_attached_file :blank_image,    storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  has_attached_file :static_pdf,     storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }

  validates_attachment_content_type :thumbnail,      content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :numbered_image, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :blank_image,    content_type: /\Aimage\/.*\z/

  def croppable?
    blank_image.exists?
  end

  protected

  def set_blank_image_dimensions
    if blank_image.exists?
      self.blank_image_height = sprintf("%0.02f", dimensions(:blank_image)[:height].to_f)
      self.blank_image_width  = sprintf("%0.02f", dimensions(:blank_image)[:width].to_f)
    end
  end
end
