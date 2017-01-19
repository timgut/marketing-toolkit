class CreateImagesUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :images_users do |t|
      t.belongs_to :image
      t.belongs_to :user
      t.timestamps
    end
  end
end
