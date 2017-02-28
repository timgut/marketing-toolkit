# Breadcrumbs won't display without a parent. This is a fake parent that's hidden.
crumb :root do
  link "", "#"
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
crumb :templates do |campaign|
  link "Templates", campaign_templates_path(campaign)
  parent campaign
end

crumb :new_template do |campaign|
  link "New Template", new_campaign_template_path(campaign)
  parent campaign
end

crumb :edit_template do |campaign, template|
  link "Edit #{template.title}", edit_campaign_template_path(campaign, template)
  parent campaign
end

crumb :template do |campaign, template|
  link template.title, campaign_template_path(campaign, template)
  parent :templates, campaign
end

# Flyers
crumb :flyers do
  link "Flyers", flyers_path
  parent :root
end

crumb :new_flyer do |campaign, template|
  link "New Flyer", new_campaign_template_flyer_path(campaign, template)
  parent :template, campaign, template
end

crumb :edit_flyer do |campaign, template|
  link "Edit #{template.title}", edit_campaign_template_path(campaign, template)
  parent :template, campaign, template
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

# Users
crumb :users do
  link "Manage Users", users_path
end

crumb :edit_user do |user|
  link user.name, edit_user_registration_path
  parent :users
end

