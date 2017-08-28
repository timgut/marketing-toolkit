class AddCropMarksToTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :templates, :crop_marks, :integer, default: 0, null: false
  end
end
