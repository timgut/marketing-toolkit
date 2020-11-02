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

  def upload_to_s3!(user_id)
    # Persist the tempfile
    filename = image_url.split("/").last
    tmp_path = Rails.root.join("tmp").join("#{DateTime.now.to_i}-#{}")

    open(URI(image_url)) { |tmp_file| File.open(tmp_path, 'wb') {|file| file << tmp_file.read} }

    # Upload to S3
    fullpath = s3_path(filename: filename, user_id: user_id)
    service  = Aws::S3::Resource.new(region: "us-east-1", http_wire_trace: true)
    object   = service.bucket("toolkit.afscme.org").object(fullpath)
    object.upload_file(tmp_path, acl: "public-read")

    # Cleanup
    url = "https://s3.amazonaws.com/toolkit.afscme.org/#{fullpath}"
    FileUtils.rm(tmp_path)
    image = Image.create!(creator_id: user_id, status: 1, original_image_url: url, cropped_image_url: url, crop_data: nil)
    ImageUser.create!(image_id: image.id, user_id: user_id)
  end
end
  