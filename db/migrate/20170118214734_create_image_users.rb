class CreateImageUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :image_users do |t|

      t.timestamps
    end
  end
end
