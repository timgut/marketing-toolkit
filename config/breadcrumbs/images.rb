# Images
crumb :index_images do
  link "My Images", images_path
  parent :documents 
end

crumb :recent_images do
  link "Recent Images", recent_images_path
  parent :index_images
end

crumb :shared_images do
  link "Shared Images", shared_images_path
  parent :index_images
end

crumb :new_image do
  link "New Image", new_image_path
  parent :index_images
end

crumb :edit_image do |image|
  link "Edit '#{image.image_file_name}'", edit_image_path(image)
  parent :index_images
end

crumb :image do |image|
  link image.image_file_name, image_path(image)
  parent :index_images
end
