class AddShareGraphicsToTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :templates, :mini_magick_markup, :text
    add_column :templates, :unit, :string
    add_column :templates, :format, :string
  end
end
