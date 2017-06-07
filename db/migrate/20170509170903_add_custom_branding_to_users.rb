class AddCustomBrandingToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :custom_branding, :boolean, default: false
  end
end
