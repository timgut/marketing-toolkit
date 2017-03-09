class AddAffiliatesFkToUsers < ActiveRecord::Migration[5.0]
  def change
  	add_column :users, :affiliate_id, :integer
  	add_index :users, :affiliate_id
  end
end
