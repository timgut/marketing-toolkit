class CreateCampaignsFlyers < ActiveRecord::Migration[5.0]
  def change
    create_table :campaigns_flyers do |t|
      t.belongs_to :campaign
      t.belongs_to :flyer
      t.belongs_to :creator
      t.timestamps
    end
  end
end
