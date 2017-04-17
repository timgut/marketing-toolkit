class Template < ApplicationRecord
  include Status

  has_many :documents

  belongs_to :campaign
  belongs_to :category

  validates_presence_of :title, :description, :height, :width, :pdf_markup, :form_markup, :status
  validates_numericality_of :height, :width

  scope :with_category, ->(category_id){ where(category_id: category_id) }

  has_attached_file :thumbnail,      storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  has_attached_file :numbered_image, storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  has_attached_file :blank_image,    storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }

  validates_attachment_content_type :thumbnail,      content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :numbered_image, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :blank_image,    content_type: /\Aimage\/.*\z/

  def croppable?
    !blank_image_file_name.nil?
  end
end
