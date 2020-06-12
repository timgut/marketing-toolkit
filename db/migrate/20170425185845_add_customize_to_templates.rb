class AddCustomizeToTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :templates, :customize, :boolean, default: true
    # add_attachment :templates, :static_pdf
  end
end
