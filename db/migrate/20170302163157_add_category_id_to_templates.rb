class AddCategoryIdToTemplates < ActiveRecord::Migration[5.0]
  def change
  	add_column :templates, :category_id, :integer
  end
end
