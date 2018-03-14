class CreateCampaignsTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :campaigns_templates do |t|
      t.belongs_to :campaign
      t.belongs_to :template
      t.timestamps
    end
  end
end
