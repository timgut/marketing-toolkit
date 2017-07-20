class DocumentThumbnailJob < ApplicationJob
  queue_as :default

  def perform(document)
    ActiveRecord::Base.connection_pool.with_connection do
      document.generate_thumbnail
    end
  end
end
