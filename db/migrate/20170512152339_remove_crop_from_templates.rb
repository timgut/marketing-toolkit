class RemoveCropFromTemplates < ActiveRecord::Migration[5.0]
  def change
    # remove_column :templates, :crop_top
    # remove_column :templates, :crop_bottom
    remove_column :templates, :blank_image_height
    remove_column :templates, :blank_image_width
  end
end
