class AddAuditToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :audit, :text
  end
end
