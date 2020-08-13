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
  
  scope :rendered, -> { where("pdf_url != NULL OR pdf_url != '/missing.png' OR share_graphic_url != NULL OR share_graphic_url != '/missing.png' ") }
  scope :newest,   -> { order(created_at: :desc) }

  attr_accessor :debug_pdf

  ### GENERATOR METHODS
  def generate_pdf
    reload # Grab the latest copy from the database

    av = ActionView::Base.new
    av.view_paths = ActionController::Base.view_paths
    pdf_html = av.render(template: "documents/build.pdf.erb", locals: {document: self})
    pdf = WickedPdf.new.pdf_from_string(pdf_html, pdf_options)

    File.open(pdf_path, 'wb') {|file| file << pdf}
    upload_to_s3!(filepath: pdf_path)
  end

  def generate_share_graphic
    reload # Grab the latest copy from the database
    config = Rails.application.config.wkhtmltoimage

    %x(#{config["cmd"]} --quality 100 --format jpg #{config["host"]}/documents/#{id}/preview #{share_graphic_path})

    upload_to_s3!(filepath: share_graphic_path)
  end

  def generate_thumbnail
    # Assign the correct paths depending on the type of template
    case template.format
    when "pdf"
      document_path = pdf_path
      thumb_path    = pdf_thumbnail_path
    when "png"
      document_path = share_graphic_path
      thumb_path    = share_graphic_thumbnail_path
    end

    # Create a thumbnail from the document
    thumb = ::MiniMagick::Image.open(document_path) 
    thumb.format "png"
    thumb.resize "348x269"
    
    # Save the thumbnail and upload it to S3
    FileUtils.cp(thumb.path, thumb_path)
    upload_to_s3!(filepath: thumb_path)
  end

  ### PATHING METHODS
  # => /rails_root/public/pdfs/1.pdf
  def pdf_path
    Rails.root.join("public", "pdfs", "#{id}.pdf").to_s
  end

  # => /rails_root/public/pdfs/1_thumb.png
  def pdf_thumbnail_path
    Rails.root.join("public", "pdfs", "#{id}_thumb.png").to_s
  end

  # => /rails_root/public/share_graphics/1.jpg
  def share_graphic_path
    Rails.root.join("public", "share_graphics", "#{id}.jpg").to_s
  end

  # => /rails_root/public/share_graphics/1_thumb.png
  def share_graphic_thumbnail_path
    Rails.root.join("public", "share_graphics", "#{id}_thumb.png").to_s
  end

  ### URL METHODS
  # => https://s3.amazonaws.com/toolkit.afscme.org/folder/1.pdf
  def pdf_s3_url
    "https://s3.amazonaws.com/toolkit.afscme.org/#{s3_path(filename: "#{id}.pdf")}"
  end

  # => https://s3.amazonaws.com/toolkit.afscme.org/folder/1_thumb.png
  def thumbnail_s3_url
    "https://s3.amazonaws.com/toolkit.afscme.org/#{s3_path(filename: "#{id}_thumb.png")}"
  end

  # => https://s3.amazonaws.com/toolkit.afscme.org/folder/1.jpg
  def share_graphic_s3_url
    "https://s3.amazonaws.com/toolkit.afscme.org/#{s3_path(filename: "#{id}.jpg")}"
  end
  
  # => https://toolkit.afscme.org/pdfs/1_thumb.png
  def pdf_thumbnail_url
    "#{Rails.application.config.wkhtmltoimage["host"]}/pdfs/#{id}_thumb.png"
  end

  # => https://toolkit.afscme.org/pdfs/1.pdf?1234567890
  def pdf_url_with_timestamp
    "#{pdf_url}?#{DateTime.now.to_i}"
  end

  # => https://toolkit.afscme.org/share_graphics/1.jpg?1234567890
  def share_graphic_url_with_timestamp
    "#{share_graphic_url}?#{DateTime.now.to_i}"
  end

  # OTHER METHODS
  def method_missing(meth, *args, &block)
    data.find{|d| d.key == meth.to_s}&.value || ""
  end

  # Updates the document with S3 URLs for all the documents, and deletes all files from the local filesystem.
  def cleanup!
    case template.format
    when "pdf"
      update!(pdf_url: pdf_s3_url, thumbnail_url: thumbnail_s3_url, share_graphic_url: nil)
    when "png"
      update!(share_graphic_url: share_graphic_s3_url, thumbnail_url: thumbnail_s3_url, pdf_url: nil)
    end

    begin
      [pdf_path, pdf_thumbnail_path, share_graphic_path, share_graphic_thumbnail_path].each do |path|
        FileUtils.rm(path)
      end
    rescue => e
      # File doesn't exist. We don't care.
    end

    self.update!(generated: true)
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
      zoom:          1,
      margin:        { top: 0, bottom: 0, left: 0, right: 0 }
    }
  end

  # PAPERCLIP LEGACY METHODS
  def pdf
    OpenStruct.new(url: pdf_url)
  end

  def thumbnail
    OpenStruct.new(url: pdf_thumbnail_url)
  end
end
