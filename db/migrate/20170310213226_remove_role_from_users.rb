class RemoveRoleFromUsers < ActiveRecord::Migration[5.0]
  def change
  	remove_column :users, :region
  end
end
