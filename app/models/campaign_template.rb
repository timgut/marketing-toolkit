class CampaignTemplate < ApplicationRecord
  self.table_name = :campaigns_templates

  belongs_to :campaign
  belongs_to :template
end
