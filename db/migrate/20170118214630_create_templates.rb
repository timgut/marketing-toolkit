class CreateTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :templates do |t|
      t.string :title
      t.text :description
      t.float :height
      t.float :width
      t.timestamps
    end
  end
end
