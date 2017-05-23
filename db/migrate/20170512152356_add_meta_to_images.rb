class AddMetaToImages < ActiveRecord::Migration[5.0]
  def change
    add_column :images, :image_meta, :text
    add_column :templates, :blank_image_meta, :text
  end
end
