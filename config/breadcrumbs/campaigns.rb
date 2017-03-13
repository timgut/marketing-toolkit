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
