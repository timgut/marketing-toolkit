class CreateCampaignsFlyers < ActiveRecord::Migration[5.0]
  def change
    create_table :campaigns_flyers do |t|
      t.belongs_to :campaign
      t.belongs_to :flyer
      t.timestamps
    end
  end
end
