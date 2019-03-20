# Images
crumb :index_stock_images do
  link "Stock Images", images_path
end

crumb :new_stock_image do
  link "New Stock Image", new_admin_stock_image_path
  parent :index_stock_images
end

crumb :edit_stock_image do |stock_image|
  link "Edit '#{stock_image.image_file_name}'", edit_admin_stock_image_path(stock_image)
  parent :index_stock_images
end

crumb :stock_image do |stock_image|
  link stock_image.image_file_name, admin_stock_image_path(stock_image)
  parent :index_stock_images
end
