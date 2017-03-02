class Template < ApplicationRecord
  include Status

  belongs_to :campaign

  has_many :documents

  validates_presence_of :title, :description, :height, :width, :pdf_markup, :form_markup, :status
  validates_numericality_of :height, :width

  has_attached_file :thumbnail,      storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  has_attached_file :numbered_image, storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  has_attached_file :blank_image,    storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }

  validates_attachment_content_type :thumbnail,      content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :numbered_image, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :blank_image,    content_type: /\Aimage\/.*\z/
end
