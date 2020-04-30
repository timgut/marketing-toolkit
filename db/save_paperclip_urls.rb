# Run with: bin/rails c
# load Rails.root.join("db", "save_paperclip_urls.rb")
Image.all.each do |image|
  image.update_attributes!(
    original_image_url: image.image.url(:original).sub("/system", ""),
    cropped_image_url:  image.image.url(:cropped).sub("/system", "")
  )
end

Template.all.each do |template|
  template.update_attributes!(
    thumbnail_url:      template.thumbnail.url.sub("/system", ""),
    numbered_image_url: template.numbered_image.url.sub("/system", ""),
    blank_image_url:    template.blank_image.url.sub("/system", ""),
    static_pdf_url:     template.static_pdf.url.sub("/system", "")
  )
end

StockImage.all.each do |image|
  image.update_attributes!(image_url: image.image.url.sub("/system", ""))
end

Document.all.each do |document|
  document.update_attributes!(
    pdf_url:           document.pdf.url.sub("/system", ""),
    thumbnail_url:     document.thumbnail.url.sub("/system", ""),
    share_graphic_url: documentshare_graphic.url.sub("/system", ""),
  )
end
