class CreateFlyers < ActiveRecord::Migration[5.0]
  def change
    create_table :flyers do |t|
      t.belongs_to :template
      t.string :title
      t.text :description
      t.integer :status
      t.integer :folder_id
      t.attachment :pdf
      t.timestamps
    end
  end
end
