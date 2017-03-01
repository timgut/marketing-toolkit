class AddFieldIdToData < ActiveRecord::Migration[5.0]
  def change
    add_column :data, :field_id, :string
  end
end
