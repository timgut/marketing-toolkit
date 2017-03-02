class RenameFlyersToDocuments < ActiveRecord::Migration[5.0]
  def change
    rename_table :flyers, :documents
    add_column :document, :tag_id, :integer

    rename_table :flyers_users, :documents_users
    rename_column :documents_users, :flyer_id, :document_id

    rename_table :campaigns_flyers, :campaigns_documents
    rename_column :campaigns_documents, :flyer_id, :document_id

    rename_column :data, :flyer_id, :document_id
  end
end
