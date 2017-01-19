class CreateFields < ActiveRecord::Migration[5.0]
  def change
    create_table :fields do |t|
      t.belongs_to :template
      t.string :key
      t.string :type
      t.integer :group
      t.timestamps
    end
  end
end
