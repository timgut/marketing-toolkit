class CreateFolders < ActiveRecord::Migration[5.0]
  def change
    create_table :folders do |t|
      t.string :name
      t.string :path
      t.integer :parent_id
      t.integer :user_id
      t.boolean :is_root
      t.timestamps
    end
  end
end
