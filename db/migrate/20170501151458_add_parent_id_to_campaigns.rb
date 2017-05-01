class AddParentIdToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :parent_id, :integer, default: nil
  end
end
