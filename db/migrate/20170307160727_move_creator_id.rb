class MoveCreatorId < ActiveRecord::Migration[5.0]
  def change
    remove_column :documents_users, :creator_id
    remove_column :images_users, :creator_id

    add_column :documents, :creator_id, :integer
    add_column :images, :creator_id, :integer

    add_index :documents, :creator_id
    add_index :images, :creator_id
  end
end
