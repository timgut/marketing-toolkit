class StockImage < ApplicationRecord
  include Status

  class << self
    def find_by_url(url)
      StockImage.find_by(image_url: url)
    end
  end

  # Filenames have the two dashes (--) and 10 digit timestamp removed.
  def filename
    @friendly_filename ||= if image_url
      filename = image_url.split("/").last.split(".").first
      filename.sub(/--\d{10}/, "")
    else
      "TODO"
    end
  end
end
  