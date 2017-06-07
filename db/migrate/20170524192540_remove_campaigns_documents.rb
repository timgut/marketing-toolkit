class RemoveCampaignsDocuments < ActiveRecord::Migration[5.0]
  def change
    drop_table :campaigns_documents
  end
end
