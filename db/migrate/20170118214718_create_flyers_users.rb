class CreateFlyersUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :flyers_users do |t|
      t.belongs_to :flyer
      t.belongs_to :user
      t.belongs_to :creator
      t.timestamps
    end
  end
end
