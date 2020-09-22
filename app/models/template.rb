class Template < ApplicationRecord
  include Status

  enum crop_marks: [:no_crop_marks, :false_by_default, :true_by_default]

  has_many :documents
  has_and_belongs_to_many :campaigns, join_table: :campaigns_templates, optional: true
  belongs_to :category, optional: true

  validates :title, :description, :height, :width, :format, :unit, :status, presence: true, if: Proc.new{|t| t.customize?}
  validates :height, :width, numericality: true, if: Proc.new{|t| t.customize?}

  scope :with_category, ->(category_id){ where(category_id: category_id) }
  default_scope ->{ order(position: :asc) }

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
    !blank_image_url.blank?
  end

  def set_campaigns!(campaigns)
    CampaignTemplate.where(template_id: id).destroy_all

    Array(campaigns).each do |campaign|
      unless campaign.blank?
        CampaignTemplate.create!(campaign_id: campaign, template_id: id)
      end
    end
  end

  def upload_image_to_s3(file)
    path = Rails.root.join("tmp", file.original_filename).to_s
    FileUtils.cp(file.tempfile, path)
    upload_to_s3!(filepath: path)
    FileUtils.rm(path)
  end

  def has_static_pdf?
    !static_pdf_url.nil? && static_pdf_url != "" && static_pdf_url != "/static_pdfs/original/missing.png"
  end
  
  def has_blank_image?
    !blank_image_url.nil? && blank_image_url != "" && blank_image_url != "/blank_images/original/missing.png"
  end
  
  def has_numbered_image?
    !numbered_image_url.nil? && numbered_image_url != "" && numbered_image_url != "/numbered_images/original/missing.png"
  end

  def has_thumbnail?
    !thumbnail_url.nil? && thumbnail_url != "" && thumbnail_url != "/thumbnails/original/missing.png"
  end

  # Legacy Paperclip Images
  def blank_image
    OpenStruct.new(url: blank_image_url)
  end

  def numbered_image
    OpenStruct.new(url: numbered_image_url)
  end

  def thumbnail
    OpenStruct.new(url: thumbnail_url)
  end
end
