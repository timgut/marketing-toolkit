class AddLabelToStockImages < ActiveRecord::Migration[5.2]
  def change
    add_column :stock_images, :label, :string
  end
end
