class RemovePaperclip < ActiveRecord::Migration[5.2]
  def change
    remove_attachment :images, :image
    remove_column     :images, :image_meta

    remove_attachment :templates, :thumbnail
    remove_attachment :templates, :numbered_image
    remove_attachment :templates, :blank_image
    remove_attachment :templates, :static_pdf
    remove_column     :templates, :blank_image_meta

    remove_attachment :stock_images, :image

    remove_attachment :documents, :pdf
    remove_attachment :documents, :thumbnail
    remove_attachment :documents, :share_graphic
  end
end
