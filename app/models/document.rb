class Document < ApplicationRecord
  include Status

  has_attached_file :pdf,       storage: :s3, s3_protocol: "https", s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  has_attached_file :thumbnail, storage: :s3, s3_protocol: "https", s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  
  validates_attachment :pdf,       content_type: {content_type: "application/pdf"}
  validates_attachment :thumbnail, content_type: {content_type: /\Aimage\/.*\z/}

  has_and_belongs_to_many :users
  
  has_many :data
  has_many :document_users, class_name: "DocumentUser"

  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  belongs_to :template

  validates_presence_of :template, :title, :description, :status

  scope :recent,         ->(user) { where("documents.creator_id = ? AND documents.created_at >= ?", user.id, DateTime.now - 2.weeks) }
  scope :shared_with_me, ->(user) { all.joins(:documents_users).where("user_id = ? and documents_users.user_id != ?", user.id, user.id) }

  before_destroy   ->{ self.pdf = nil }

  attr_accessor :debug_pdf

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

  def filename
    "#{id}.pdf"
  end

  def generate_pdf
    av = ActionView::Base.new
    av.view_paths = ActionController::Base.view_paths
    pdf_html = av.render template: "documents/build.pdf.erb", locals: {document: self}
    pdf = WickedPdf.new.pdf_from_string(pdf_html, pdf_options)

    File.open(local_pdf_path, 'wb') {|file| file << pdf}
    
    self.pdf = File.open(local_pdf_path)
    self.save

    # Save the file for thumbnail generation
    # File.delete(local_pdf_path)
  end

  def generate_thumbnail
    thumb = MiniMagick::Image.open(local_pdf_path) 
    thumb.format "png"
    thumb.resize "348x269"
    
    FileUtils.cp(thumb.path, local_thumbnail_path)

    self.thumbnail = File.open(local_thumbnail_path)
    self.save
    
    File.delete(local_thumbnail_path)
  end

  def local_pdf_path
    Rails.root.join("public", "pdfs", filename).to_s
  end

  def local_thumbnail_path
    Rails.root.join("public", "pdfs", "#{id}.png").to_s
  end

  private

  def pdf_options
    {
      pdf:           title,
      template:      "documents/build.pdf.erb",
      disposition:   :inline,
      orientation:   template.orientation,
      grayscale:     false,
      lowquality:    false,
      image_quality: 94,
      show_as_html:  self.debug_pdf,
      page_height:   "#{template.height}in",
      page_width:    "#{template.width}in",
      zoom: 1,
      margin:  {
        top:    0,
        bottom: 0,
        left:   0,
        right:  0
      }
    }
  end
end
