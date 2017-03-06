class Document < ApplicationRecord
  include Status

  has_attached_file :pdf, storage: :s3, s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  validates_attachment :pdf, content_type: {content_type: "application/pdf"}

  has_and_belongs_to_many :campaigns
  has_and_belongs_to_many :users
  
  has_many :data
  
  belongs_to :template

  validates_presence_of :template, :title, :description, :status

  scope :recent,         ->{ where("created_at >= ?", DateTime.now - 1.month) }
  scope :shared_with_me, ->{ all.joins(:documents_users).where("documents_users.creator_id != ?", User.current_user.id) }

  attr_accessor :defined_data_methods

  after_initialize ->{ self.defined_data_methods = false }
  before_destroy   ->{ self.pdf = nil }

  # If a Datum record doesn't exist for this document, don't raise an error.
  # But log something annoying so we don't forget about it.
  # And return a String because that's the kind of data we're expecting.
  def method_missing(method, *args, &block)
    unless self.defined_data_methods
      define_data_methods
    end

    Rails.logger.info "*"*60
    Rails.logger.info "Missing method: #{method}"
    Rails.logger.info "Returning an empty string for now"
    Rails.logger.info "*"*60

    ""
  end

  def local_pdf_path
    Rails.root.join("public", "pdfs", filename).to_s
  end

  def filename
    "#{id}.pdf"
  end

  protected

  def define_data_methods
    self.defined_data_methods = true

    data.each do |datum|
      self.class.__send__(:define_method, datum.key) do
        datum.value.try(:html_safe)
      end
    end
  end
end
