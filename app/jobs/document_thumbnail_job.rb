class DocumentThumbnailJob < ApplicationJob
  queue_as :default

  def perform(document)
    Rails.logger.tagged("DocumentThumbnailJob", "#{document.id}") do
      ActiveRecord::Base.connection_pool.with_connection do
        document.generate_thumbnail
      end
    end
  end
end
