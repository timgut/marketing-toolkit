class CreateAffiliates < ActiveRecord::Migration[5.0]
  def change
    create_table :affiliates do |t|
      t.string :title
      t.string :slug
      t.string :state
      t.string :region
      t.timestamps
    end
  end
end
