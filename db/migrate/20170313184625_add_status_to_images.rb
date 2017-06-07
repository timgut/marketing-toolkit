class AddStatusToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :status, :integer, default: 1
  end
end
