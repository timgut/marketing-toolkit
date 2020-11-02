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

  def upload_to_s3!
    # Persist the tempfile
    filename = image_url.split("/").last
    tmp_path = Rails.root.join("tmp").join("#{DateTime.now.to_i}-#{}")

    open(URI(image_url)) { |tmp_file| File.open(tmp_path, 'wb') {|file| file << tmp_file.read} }

    # Upload to S3
    fullpath = s3_path(filename: filename)
    service  = Aws::S3::Resource.new(region: "us-east-1", http_wire_trace: true)
    object   = service.bucket("toolkit.afscme.org").object(fullpath)
    object.upload_file(tmp_path, acl: "public-read")

    # Cleanup
    FileUtils.rm(tmp_path)
    self.update!(original_image_url: "https://s3.amazonaws.com/toolkit.afscme.org/#{fullpath}")
  end
end
  