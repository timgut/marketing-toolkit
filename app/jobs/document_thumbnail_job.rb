class DocumentThumbnailJob < ApplicationJob
  queue_as :default

  def perform(document)
    Rails.logger.tagged("DocumentThumbnailJob", "#{document.id}") do
      ActiveRecord::Base.connection_pool.with_connection do
        document.generate_thumbnail
        document.delete_local_pdf
      end
    end
  end
end
