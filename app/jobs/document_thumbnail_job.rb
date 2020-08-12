class DocumentThumbnailJob < ApplicationJob
  queue_as :default

  def perform(document)
    Rails.logger.tagged("DocumentThumbnailJob", "#{document.id}") do
      ActiveRecord::Base.connection_pool.with_connection do
        document.generate_thumbnail

        # Delete the original document since we don't need a local copy anymore.
        begin
          # case document.template.format
          # when "pdf"  
          #   document.delete_local_pdf
          # when "png"
          #   document.delete_local_share_graphic
          # end
        rescue
          # Silently fail if the file doesn't exist anymore
        end
      end
    end
  end
end
