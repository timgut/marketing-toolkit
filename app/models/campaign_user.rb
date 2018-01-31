class CampaignUser < ApplicationRecord
  self.table_name = :campaigns_users

  belongs_to :campaign
  belongs_to :user
end
