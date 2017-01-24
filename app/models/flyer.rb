class Flyer < ApplicationRecord
  include Status

  has_attached_file :pdf, storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  validates_attachment :pdf, content_type: {content_type: "application/pdf"}

  has_and_belongs_to_many :campaigns
  has_and_belongs_to_many :users
  
  has_many :data
  
  belongs_to :template

  validates_presence_of :template, :title, :description, :status

  after_initialize :define_data_methods

  def generated?
    File.file?(absolute_pdf_path)
  end

  def absolute_pdf_path
    Rails.root.join("public", "pdfs", "#{id}.pdf").to_s
  end

  def relative_pdf_path
    "/pdfs/#{id}.pdf"
  end

  protected

  def define_data_methods
    data.each do |datum|
      self.class.__send__(:define_method, datum.key) do
        datum.value
      end
    end
  end

  def s3_credentials
    {
      s3_region:        "us-east-1",
      bucket:           "toolkit.afscme.org",
      path:              "/#{Rails.application.secrets.aws["folder"]}/pdfs/:id/:filename.:extension",
      access_key_id:     Rails.application.secrets.aws["access_key_id"],
      secret_access_key: Rails.application.secrets.aws["secret_access_key"]
    }
  end
end
