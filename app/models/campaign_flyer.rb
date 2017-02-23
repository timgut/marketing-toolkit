class CampaignFlyer < ApplicationRecord
  self.table_name = :campaigns_flyers

  belongs_to :campaign
  belongs_to :flyer
end
