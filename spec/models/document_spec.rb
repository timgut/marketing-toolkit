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

  describe "Paperclip" do
    describe "pdf" do
      it "has an attachment" do
        expect(Document).to have_attached_file(:pdf)
      end

      it "validates the content_type is a PDF" do
        expect(Document).to validate_attachment_content_type(:pdf).
          rejecting("image/png", "image/gif", "image/jpg", "image/jpeg").
          allowing("application/pdf")
      end
    end
  end

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
    describe ".recent" do
      it "displays documents from the last 2 weeks" do
        old_doc = create(:document, creator: user, created_at: DateTime.now - 1.month)
        new_doc = create(:document, creator: user, created_at: DateTime.now - 1.week)

        expect(Document.recent(user)).to include new_doc
        expect(Document.recent(user)).not_to include old_doc
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

  describe "attr_accessor" do
    before(:each) do
      document.current_user = user
    end

    describe "self.called_data_methods" do
      it "keeps track of methods delegated to #method_missing" do
        document.fake_method1

        expect(document.called_data_methods).to eq [{
          method:      :fake_method1,
          method_type: :method_missing,
          document_id: document.id,
          user_id:     document.current_user.id
        }]
      end
    end
  end

  describe "Instance Methods" do
    describe "#duplicate!" do
      it "creates a new Document and DocumentUser" do
        expect { document.duplicate!(user) }.to change(Document,     :count).by(1)
        expect { document.duplicate!(user) }.to change(DocumentUser, :count).by(1)
      end

      it "erases the PDF for the duplicated document" do
        document.duplicate!(user)
        expect(Document.last.pdf_file_name).to eq nil
      end

      it "duplicates data records" do
        document.duplicate!(user)
        new_document = Document.last

        expect(new_document.headline).to eq document.headline
        expect(new_document.quote).to eq document.quote
        expect(new_document.attribution).to eq document.attribution
      end

      it "returns the new document when successful" do
        expect(document.duplicate!(user)).to eq Document.last
      end

      it "rescues errors and returns false" do
        expect(document.duplicate!(nil)).to eq false
      end
    end

    describe "#method_missing" do
      it "assumes a Datum record was called and returns an empty string" do
        expect(document.my_fake_method).to eq ""
      end
    end

    describe "#create_debugger_rows!" do
      before(:each) do
        document.current_user = user
      end

      it "creates a new Debugger for each called_data_methods" do
        document.headline

        expect { document.create_debugger_rows! }.to change(Debugger, :count).by(1)
      end

      it "records the error when one is raised" do
        message = "Something went wrong."
        allow(Debugger).to receive(:create!).and_raise(message)

        document.fake_method1
        document.create_debugger_rows!

        expect(Debugger.last.notes).to eq message
      end
    end
  end
end
