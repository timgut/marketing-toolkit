class CreateStockImages < ActiveRecord::Migration[5.2]
  def change
    create_table :stock_images do |t|
      t.string :title
      # t.attachment :image
      t.integer :status, default: 1
      t.timestamps
    end
  end
end
