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
    before(:each) do
      allow(User).to receive(:current_user).and_return(user)
    end

    describe ".recent" do
      it "displays documents from the last 2 weeks" do
        old_doc = create(:document, creator: user, created_at: DateTime.now - 1.month)
        new_doc = create(:document, creator: user, created_at: DateTime.now - 1.week)

        expect(Document.recent).to include new_doc
        expect(Document.recent).not_to include old_doc
      end
    end
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
        document.define_data_methods

        expect(document.respond_to?(:headline)).to eq true
        expect(document.headline).to eq "You never quit. That's why we never rest."

        expect(document.respond_to?(:quote)).to eq true
        expect(document.quote).to eq "\"I'm proud of the work I do to make my community better. I couldn't do it without my union.\""

        expect(document.respond_to?(:attribution)).to eq true
        expect(document.attribution).to eq "Clerical"
      end
    end

    describe "#duplicate!" do
      before(:each) do
        allow(User).to receive(:current_user).and_return(user)
      end

      it "creates a new Document and DocumentUser" do
        expect { document.duplicate! }.to change(Document,     :count).by(1)
        expect { document.duplicate! }.to change(DocumentUser, :count).by(1)
      end

      it "erases the PDF for the duplicated document" do
        document.duplicate!
        expect(Document.last.pdf_file_name).to eq nil
      end

      it "duplicates data records" do
        document.duplicate!
        new_document = Document.last

        expect(new_document.headline).to eq document.headline
        expect(new_document.quote).to eq document.quote
        expect(new_document.attribution).to eq document.attribution
      end

      it "returns the new document when successful" do
        expect(document.duplicate!).to eq Document.last
      end

      it "rescues errors and returns false" do
        allow(User).to receive(:current_user).and_return(nil)
        expect(document.duplicate!).to eq false
      end
    end
  end
end
