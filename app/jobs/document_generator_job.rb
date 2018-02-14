class DocumentGeneratorJob < ApplicationJob
  queue_as :default

  def perform(document)
    Rails.logger.tagged("DocumentGenerator", "#{document.id}") do
      ActiveRecord::Base.connection_pool.with_connection do
        case document.template.format
        when "pdf"
          document.generate_pdf
        when "png"
          document.generate_share_graphic
        end
      end

      DocumentThumbnailJob.perform_later(document)
    end
  end
end
