require 'rails_helper'

RSpec.describe Document, type: :model do
  let!(:user)     { create(:user) }
  let!(:campaign) { create(:campaign) }
  let!(:template) { create(:template) }
  let!(:document) { create(:document, template: template) }

  let!(:data) {[
    create(:datum, document: document, key: "headline", value: "You never quit. That's why we never rest."),
    create(:datum, document: document, key: "quote", value: "\"I'm proud of the work I do to make my community better. I couldn't do it without my union.\""),
    create(:datum, document: document, key: "attribution", value: "Clerical")
  ]}

  before(:each){ document.reload }

  describe "Associations" do
    it "has_and_belongs_to_many campaigns" do
      expect(document).to respond_to(:campaigns)
    end

    it "has_and_belongs_to_many users" do
      expect(document).to respond_to(:users)
    end

    it "has_many data" do
      expect(document).to respond_to(:data)
    end

    it "has_many document_users" do
      expect(document).to respond_to(:document_users)
    end

    it "belongs_to creator" do
      expect(document).to respond_to(:creator)
    end

    it "belongs_to template" do
      expect(document).to respond_to(:template)
    end
  end

  describe "Scopes" do
  end

  describe "Validations" do
    it "validates_presence_of document, key" do
      expect { invalid = Datum.create!(document: nil) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { invalid = Datum.create!(key: nil)      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "Concerns" do
    it_behaves_like "Status" do
      let!(:record) { document }
    end
  end

  describe "Class Methods" do
  end

  describe "Instance Methods" do
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
end
