class AddOrientationToTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :templates, :orientation, :string
  end
end
