class DocumentGeneratorJob < ApplicationJob
  queue_as :default

  def perform(document, user)
    Rails.logger.tagged("DocumentGenerator", "#{document.id}") do
      ActiveRecord::Base.connection_pool.with_connection do
        case document.template.format
        when "pdf"
          document.generate_pdf(user.id)
        when "png"
          document.generate_share_graphic(user.id)
        end

        DocumentThumbnailJob.perform_later(document)
      end
    end
  end
end
