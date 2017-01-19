class CreateData < ActiveRecord::Migration[5.0]
  def change
    create_table :data do |t|
      t.belongs_to :flyer
      t.string :key
      t.string :value
      t.timestamps
    end
  end
end
