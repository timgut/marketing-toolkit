class DocumentThumbnailJob < ApplicationJob
  queue_as :default

  def perform(document)
    Rails.logger.tagged("DocumentThumbnailJob", "#{document.id}") do
      ActiveRecord::Base.connection_pool.with_connection do
        case document.template.format
        when "pdf"
          document.generate_thumbnail
          document.delete_local_pdf
        when "png"
          Rails.logger.info "TODO: Generate Thumbnail!"
        end
      end
    end
  end
end
