class RemoveMiniMagickMarkupFromTemplates < ActiveRecord::Migration[5.0]
  def change
    remove_column :templates, :mini_magick_markup
  end
end
