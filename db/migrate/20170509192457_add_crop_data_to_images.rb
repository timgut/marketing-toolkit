class AddCropDataToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :crop_data, :text
  end
end
