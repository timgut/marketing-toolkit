class DocumentPdfJob < ApplicationJob
  queue_as :default

  def perform(document)
    Rails.logger.tagged("DocumentPdfJob", "#{document.id}") do
      document.generate_pdf
      DocumentThumbnailJob.perform_later(document)
    end
  end
end
