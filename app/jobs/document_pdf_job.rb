class DocumentPdfJob < ApplicationJob
  queue_as :default

  def perform(document)
    Rails.logger.tagged("DocumentPdfJob", "#{document.id}") do
      ActiveRecord::Base.connection_pool.with_connection do
        document.generate_pdf
      end

      DocumentThumbnailJob.perform_later(document)
    end
  end
end
