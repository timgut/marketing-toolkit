class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.integer :folder_id
      t.attachment :image
      t.timestamps
    end
  end
end
