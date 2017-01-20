class Flyer < ApplicationRecord
  has_and_belongs_to_many :campaigns
  has_and_belongs_to_many :users
  
  has_many :data
  
  belongs_to :template

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
end
