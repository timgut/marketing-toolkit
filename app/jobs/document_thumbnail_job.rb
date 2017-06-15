class DocumentThumbnailJob < ApplicationJob
  queue_as :default

  def perform(document)
    document.generate_thumbnail
  end
end
