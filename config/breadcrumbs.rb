# Breadcrumbs won't display without a parent. This is a fake parent that's hidden.
crumb :root do
  link "", "#"
end

# Admin
crumb :admin do 
  link "Admin", admin_root_path
end

# Admin Campaigns
crumb :admin_new_campaign do
  link "New Campaign", new_admin_campaign_path
  parent :admin_campaigns
end

crumb :admin_edit_campaign do |campaign|
  link "Edit #{campaign.title}", edit_admin_campaign_path(campaign)
  parent :admin_campaigns
end

crumb :admin_campaigns do
  link "Campaigns", admin_campaigns_path
  parent :admin
end

# Admin Categories
crumb :admin_new_category do
  link "New Category", new_admin_category_path
  parent :admin_categories
end

crumb :admin_edit_category do |category|
  link "Edit #{category.title}", edit_admin_category_path(category)
  parent :admin_categories
end

crumb :admin_categories do
  link "Categories", admin_categories_path
  parent :admin
end

# Campaigns
crumb :campaigns do
  link "Campaigns", authenticated_root_path
  parent :root
end

crumb :new_campaign do
  link "New Campaign", new_campaign_path
  parent :campaigns
end

crumb :edit_campaign do |campaign|
  link "Edit #{campaign.title}", edit_campaign_path(campaign)
  parent :campaigns
end

crumb :campaign do |campaign|
  link campaign.title, campaign_path(campaign)
  parent :campaigns
end

# Templates
crumb :templates do
  link "Templates", templates_path
  parent :root
end

crumb :new_template do
  link "New Template", new_template_path
  parent :templates
end

crumb :edit_template do |template|
  link "Edit #{template.title}", edit_template_path(template)
  parent :templates
end

crumb :template do |template|
  link template.title, template_path(template)
  parent :root
end

# Documents
crumb :documents do
  link "Documents", documents_path
  parent :root
end

crumb :new_document do |template|
  link "New Document", new_document_path
  parent :template, template
end

crumb :edit_document do |document, template|
  link "Edit #{document.title}", edit_document_path(document)
  parent :template, template
end

# Images
crumb :index_images do
  link "Images", images_path
  parent :root
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
  link "Edit #{image.image_file_name}", edit_image_path(image)
  parent :index_images
end

crumb :image do |image|
  link image.image_file_name, image_path(image)
  parent :index_images
end

# Admin Users
crumb :admin_users do
  link "Manage Users", admin_users_path
  parent :admin
end

crumb :edit_user do |user|
  link user.name, edit_user_registration_path
  parent :admin_users
end

crumb :profile do |user|
  link 'My Profile', profile_path
end

crumb :edit_password do |user|
  link 'Change Password', password_path
  parent :profile
end
