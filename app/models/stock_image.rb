class StockImage < ApplicationRecord
    include Status
  
    class << self
      def find_by_url(url)
        file_name = url.split("/").last
        begin
          StockImage.find_by!(image_file_name: file_name)
        rescue ActiveRecord::RecordNotFound
          false # Don't raise an error if the image isn't found
        end
      end
    end
  end
  