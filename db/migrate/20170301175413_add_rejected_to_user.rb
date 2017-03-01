class AddRejectedToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :rejected, :boolean
    add_index :users, :rejected
  end
end
