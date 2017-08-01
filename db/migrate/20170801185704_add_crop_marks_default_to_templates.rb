class AddCropMarksDefaultToTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :templates, :crop_marks_by_default, :boolean, default: false
  end
end
