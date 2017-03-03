require 'rails_helper'

RSpec.describe Document, type: :model do
  let!(:user)           { create(:user) }
  let!(:campaign)       { create(:campaign) }
  let!(:template)       { create(:template) }
  let!(:document)          { create(:document, template: template, folder: user.root_document_folder) }
  let!(:campaign_document) { create(:campaign_document, campaign: campaign, document: document) }
  let!(:data)           {[
    create(:datum, document: document, key: "headline", value: "You never quit. That's why we never rest."),
    create(:datum, document: document, key: "quote", value: "\"I'm proud of the work I do to make my community better. I couldn't do it without my union.\""),
    create(:datum, document: document, key: "attribution", value: "Clerical")
  ]}

  before(:each){ document.reload }

  describe "Concerns" do
    it_behaves_like "Status" do
      let!(:record) { document }
    end
  end

  describe "#define_data_methods" do
    it "creates methods for each datum" do
      expect(document.respond_to?(:headline)).to eq true
      expect(document.headline).to eq "You never quit. That's why we never rest."

      expect(document.respond_to?(:quote)).to eq true
      expect(document.quote).to eq "\"I'm proud of the work I do to make my community better. I couldn't do it without my union.\""

      expect(document.respond_to?(:attribution)).to eq true
      expect(document.attribution).to eq "Clerical"
    end
  end
end
