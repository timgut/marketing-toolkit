class Document < ApplicationRecord
  include Status

  has_and_belongs_to_many :users
  
  has_many :data
  has_many :document_users, class_name: "DocumentUser"

  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  belongs_to :template

  validates_presence_of :template, :title, :description, :status

  scope :recent,         ->(user) { where("documents.creator_id = ? AND documents.created_at >= ?", user.id, DateTime.now - 2.weeks) }
  scope :shared_with_me, ->(user) { all.joins(:documents_users).where("user_id = ? and documents_users.user_id != ?", user.id, user.id) }
  
  scope :rendered, -> { where.not(pdf_file_name: nil).or(where.not(share_graphic_file_name: nil)) }
  scope :newest,   -> { order(created_at: :desc) }

  before_destroy ->{ self.pdf = nil; self.share_graphic = nil; self.thumbnail = nil }

  attr_accessor :debug_pdf, :phantomjs_user

  def method_missing(meth, *args, &block)
    data.find{|d| d.key == meth.to_s}&.value || ""
  end

  def duplicate!(user)
    begin
      # Duplicate and save the document
      new_self = self.dup
      new_self.save!
      
      # Create the join record and remove the PDF.
      DocumentUser.create!(document_id: new_self.id, user_id: user.id)
      new_self.assign_attributes(pdf: nil)
      new_self.save!

      # Duplicate the document's data
      self.data.each do |datum|
        new_datum = datum.dup
        new_datum.document_id = new_self.id
        new_datum.save!
      end

      new_self
    rescue => e
      false
    end
  end

  def generated?
    case template.format
    when "pdf"
      self.pdf_file_name && self.thumbnail_file_name
    when "png"
      self.share_graphic_file_name #&& self.share_graphic_file_name
    end
  end

  def generate_thumbnail
    # Assign the correct paths depending on the type of template
    case template.format
    when "pdf"
      document_path = local_pdf_path
      thumb_path    = local_pdf_thumb_path
    when "png"
      document_path = local_share_graphic_path
      thumb_path    = local_share_graphic_thumb_path
    end

    # Create a thumbnail from the document
    thumb = MiniMagick::Image.open(document_path) 
    thumb.format "png"
    thumb.resize "348x269"
    
    # Update the record, and delete the local thumbnail after it's uploaded to S3.
    FileUtils.cp(thumb.path, thumb_path)
    self.thumbnail = File.open(thumb_path)
    self.save
    File.delete(thumb_path)
  end

  def delete_attachment!
    case template.format
    when "pdf"
      self.update_attributes!(pdf: nil, thumbnail: nil)
    when "png"
      self.update_attributes!(share_graphic: nil, thumbnail: nil)
    end
  end

  # Share Graphic Methods
  def generate_share_graphic
    reload # Grab the latest copy from the database
    config = Rails.application.config.wkhtmltoimage

    %x(#{config["cmd"]} --quality 100 --format jpg #{config["host"]}/documents/#{id}/preview #{local_share_graphic_path})
    self.update_attributes(share_graphic: File.open(local_share_graphic_path))
  end

  def delete_local_share_graphic
    File.delete(local_share_graphic_path)
  end

  def local_share_graphic_path
    Rails.root.join("public", "share_graphics", "#{id}.jpg").to_s
  end

  def local_share_graphic_thumb_path
    Rails.root.join("public", "share_graphics", "#{id}_thumb.png").to_s
  end

  def share_graphic_url_with_timestamp
    "#{share_graphic.url}?#{DateTime.now.to_i}"
  end

  # PDF Methods
  def generate_pdf
    reload # Grab the latest copy from the database

    av = ActionView::Base.new
    av.view_paths = ActionController::Base.view_paths
    pdf_html = av.render(template: "documents/build.pdf.erb", locals: {document: self})
    pdf = WickedPdf.new.pdf_from_string(pdf_html, pdf_options)

    File.open(local_pdf_path, 'wb') {|file| file << pdf}
    self.update_attributes(pdf: File.open(local_pdf_path))
  end

  def delete_local_pdf
    File.delete(local_pdf_path)
  end

  def local_pdf_path
    Rails.root.join("public", "pdfs", "#{id}.pdf").to_s
  end

  def local_pdf_thumb_path
    Rails.root.join("public", "pdfs", "#{id}_thumb.png").to_s
  end

  def pdf_url_with_timestamp
    "#{pdf.url}?#{DateTime.now.to_i}"
  end

  def pdf_options
    if crop_marks
      height = template.height + 0.75
      width  = template.width  + 0.75
    else
      height = template.height
      width  = template.width
    end

    {
      pdf:           title,
      template:      "documents/build.pdf.erb",
      disposition:   :inline,
      orientation:   template.orientation,
      grayscale:     false,
      lowquality:    false,
      image_quality: 94,
      show_as_html:  debug_pdf,
      page_height:   "#{height}#{template.unit}",
      page_width:    "#{width}#{template.unit}",
      zoom: 1,
      margin:  {
        top:    0,
        bottom: 0,
        left:   0,
        right:  0
      }
    }
  end

  # Legacy Paperclip Images
  def pdf
    OpenStruct.new(url: self.pdf_url)
  end

  def thumbnail
    OpenStruct.new(url: self.thumbnail_url)
  end
  
end
