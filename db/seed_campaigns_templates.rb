Template.all.each do |template|
  CampaignTemplate.create!(template_id: template.id, campaign_id: template.campaign_id)
end
