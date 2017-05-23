class AddCropDataToTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :templates, :blank_image_height, :float, default: nil
    add_column :templates, :blank_image_width,  :float, default: nil
    add_column :templates, :crop_top, :integer
    add_column :templates, :crop_bottom, :integer
  end
end
