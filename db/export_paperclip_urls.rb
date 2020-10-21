# Run with: bin/rails c
# load Rails.root.join("db", "export_paperclip_urls.rb")

CSV.open(Rails.root.join("db", "paperclip", "data", "image_urls.csv", "wb") do |csv|
  Image.all.each do |image|
    csv << [
      image.image.url(:original).sub("/system", ""),
      image.image.url(:cropped).sub("/system", "")
    ]
  end
end

CSV.open("~/template_urls.csv", "wb") do |csv|
  Template.all.each do |template|
    csv << [
    template.thumbnail.url.sub("/system", ""),
    template.numbered_image.url.sub("/system", ""),
    template.blank_image.url.sub("/system", ""),
    template.static_pdf.url.sub("/system", "")
  ]
end

CSV.open("~/stock_image_urls.csv", "wb") do |csv|
  StockImage.all.each do |image|
    csv << [image.update_attributes!(image_url: image.image.url.sub("/system", ""))]
  end
end

CSV.open("~/document_urls.csv", "wb") do |csv|
  Document.all.each do |document|
    csv << [
      document.pdf.url.sub("/system", ""),
      document.thumbnail.url.sub("/system", ""),
      documentshare_graphic.url.sub("/system", "")
    ]
  end
end
