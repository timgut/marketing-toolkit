class Document < ApplicationRecord
  include Status

  has_attached_file :pdf, storage: :s3, s3_protocol: "https", s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials) }
  validates_attachment :pdf, content_type: {content_type: "application/pdf"}

  has_and_belongs_to_many :users
  
  has_many :data
  has_many :document_users, class_name: "DocumentUser"
  has_many :debuggers

  belongs_to :creator, class_name: "User", foreign_key: :creator_id
  belongs_to :template

  validates_presence_of :template, :title, :description, :status

  scope :recent,         ->(user) { where("documents.creator_id = ? AND documents.created_at >= ?", user.id, DateTime.now - 2.weeks) }
  scope :shared_with_me, ->(user) { all.joins(:documents_users).where("user_id = ? and documents_users.user_id != ?", user.id, user.id) }

  attr_accessor :called_data_methods,  # Keeps track of every method called from #method_missing and #define_data_methods
                :current_user          # The signed in user

  after_initialize :set_attr_accessor_defaults
  before_destroy   ->{ self.pdf = nil }

  # If a Datum record doesn't exist for this document, don't raise an error.
  # But log something annoying so we know the data doesn't exist.
  # And return a String because that's the kind of data we're expecting.
  def method_missing(meth, *args, &block)
    self.called_data_methods << {
      method:      meth.to_sym,
      method_type: :method_missing,
      document_id: self.id,
      user_id:     self.current_user&.id
    }

    Rails.logger.info "*"*60
    Rails.logger.info "Missing method: #{meth}"

    if datum = data.find{|d| d.key == meth.to_s}
      datum.value
    else
      ""
    end
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

  def local_pdf_path
    Rails.root.join("public", "pdfs", filename).to_s
  end

  def create_debugger_rows!
    ActiveRecord::Base.transaction do
      self.called_data_methods.each do |debug_data|
        Debugger.create!(debug_data)
      end
    end
  rescue => e
    Debugger.create(notes: e.message)
  end

  private

  def set_attr_accessor_defaults
    self.called_data_methods = []
  end
end
