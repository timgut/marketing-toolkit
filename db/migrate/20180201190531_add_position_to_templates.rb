class AddPositionToTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :templates, :position, :integer, null: false
  end
end
