class CampaignFlyer < ApplicationRecord
  self.table_name = :campaigns_documents

  belongs_to :campaign
  belongs_to :document
end
