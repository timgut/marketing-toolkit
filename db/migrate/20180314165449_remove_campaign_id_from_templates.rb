class RemoveCampaignIdFromTemplates < ActiveRecord::Migration[5.0]
  def change
    remove_column :templates, :campaign_id
  end
end
