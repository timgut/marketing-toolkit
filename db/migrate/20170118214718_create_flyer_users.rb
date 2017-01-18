class CreateFlyerUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :flyer_users do |t|

      t.timestamps
    end
  end
end
