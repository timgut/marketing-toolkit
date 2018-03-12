class Template < ApplicationRecord
  include Status

  enum crop_marks: [:no_crop_marks, :false_by_default, :true_by_default]

  ATTACHMENTS = [:thumbnail, :numbered_image, :blank_image, :static_pdf]

  has_many :documents

  has_and_belongs_to_many :campaigns, join_table: :campaigns_templates, optional: true
  belongs_to :category, optional: true

  validates :title, :description, :height, :width, :pdf_markup, :form_markup, :status, presence: true, if: Proc.new{|t| t.customize?}
  validates :height, :width, numericality: true, if: Proc.new{|t| t.customize?}

  scope :with_category, ->(category_id){ where(category_id: category_id) }

  default_scope ->{ order(position: :asc) }

  ATTACHMENTS.each do |attachment|
    has_attached_file attachment, storage: :s3, s3_protocol: "https",  s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  end

  validates_attachment_content_type :thumbnail,      content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :numbered_image, content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :blank_image,    content_type: /\Aimage\/.*\z/
  validates_attachment_content_type :static_pdf,     content_type: "application/pdf"

  class << self
    def update_positions!(data)
      @templates = Template.find(data.keys)

      data.each do |id, position|
        template = @templates.select{|t| t.id == id.to_i}.first
        template.update_attributes!(position: position)
      end
    end
  end

  def croppable?
    blank_image.exists?
  end

  def set_campaigns!(campaigns)
    CampaignTemplate.where(template_id: id).destroy_all

    Array(campaigns).each do |campaign|
      unless campaign.blank?
        CampaignTemplate.create!(campaign_id: campaign, template_id: id)
      end
    end
  end
end
