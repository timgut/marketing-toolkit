class CreateCampaignFlyers < ActiveRecord::Migration[5.0]
  def change
    create_table :campaign_flyers do |t|

      t.timestamps
    end
  end
end
