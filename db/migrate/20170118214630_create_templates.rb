class CreateTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :templates do |t|
      t.string :title
      t.text :description
      t.float :height
      t.float :width
      t.text :pdf_markup
      t.text :form_markup
      t.integer :status
      t.timestamps
    end
  end
end
