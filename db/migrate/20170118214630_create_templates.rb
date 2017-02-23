class CreateTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :templates do |t|
      t.string :title
      t.text :description
      t.float :height
      t.float :width
      t.text :pdf_markup
      t.text :form_markup
      t.attachment :thumbnail
      t.attachment :numbered_image
      t.attachment :blank_image
      t.integer :status
      t.integer :campaign_id
      t.text :customizable_options
      t.timestamps
    end
  end
end
