class AddCropMarksToDocuments < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :crop_marks, :boolean, default: false
  end
end
