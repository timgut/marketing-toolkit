class CreateCampaignsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :campaigns_users do |t|
      t.belongs_to :campaign
      t.belongs_to :user
      t.timestamps
    end
  end
end
