require 'rails_helper'

RSpec.describe Template, type: :model do
  let!(:template) { create(:template) }

  describe "Paperclip" do
    describe "thumbnail" do
      it "has an attachment" do
        expect(Template).to have_attached_file(:thumbnail)
      end

      it "validates the content_type is an image" do
        expect(Template).to validate_attachment_content_type(:thumbnail).
          allowing("image/png", "image/gif", "image/jpg", "image/jpeg").
          rejecting("application/pdf")
      end
    end

    describe "numbered_image" do
      it "has an attachment" do
        expect(Template).to have_attached_file(:numbered_image)
      end

      it "validates the content_type is an image" do
        expect(Template).to validate_attachment_content_type(:numbered_image).
          allowing("image/png", "image/gif", "image/jpg", "image/jpeg").
          rejecting("application/pdf")
      end
    end

    describe "blank_image" do
      it "has an attachment" do
        expect(Template).to have_attached_file(:blank_image)
      end

      it "validates the content_type is an image" do
        expect(Template).to validate_attachment_content_type(:blank_image).
          allowing("image/png", "image/gif", "image/jpg", "image/jpeg").
          rejecting("application/pdf")
      end
    end

    describe "static_pdf" do
      it "has an attachment" do
        expect(Template).to have_attached_file(:static_pdf)
      end

      it "validates the content_type is a pdf" do
        expect(Template).to validate_attachment_content_type(:static_pdf).
          rejecting("image/png", "image/gif", "image/jpg", "image/jpeg").
          allowing("application/pdf")
      end
    end

  end

  describe "Associations" do
    it "has_many documents" do
      expect(template).to respond_to(:documents)
    end
    
    it "belongs_to campaign" do
      expect(template).to respond_to(:campaign)
    end
    
    it "belongs_to category" do
      expect(template).to respond_to(:category)
    end
  end

  describe "Scopes" do
    describe ".with_category" do
      it "returns templates that match the category_id" do
        category = create(:category)
        new_template = create(:template)
        template.update_attributes!(category_id: category.id)

        expect(Template.with_category(category.id)).to include template
        expect(Template.with_category(category.id)).not_to include new_template
      end
    end
  end

  describe "Validations" do
    context "when customizable" do
      it "validates presence of title, description, height, width, pdf_markup, form_markup, status" do
        expect { create(:template, title:       nil, customize: true) }.to raise_error(ActiveRecord::RecordInvalid)
        expect { create(:template, description: nil, customize: true) }.to raise_error(ActiveRecord::RecordInvalid)
        expect { create(:template, height:      nil, customize: true) }.to raise_error(ActiveRecord::RecordInvalid)
        expect { create(:template, width:       nil, customize: true) }.to raise_error(ActiveRecord::RecordInvalid)
        expect { create(:template, pdf_markup:  nil, customize: true) }.to raise_error(ActiveRecord::RecordInvalid)
        expect { create(:template, form_markup: nil, customize: true) }.to raise_error(ActiveRecord::RecordInvalid)
        expect { create(:template, status:      nil, customize: true) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "validates the numericality of height, width" do
        expect { create(:template, height: "hello", customize: true) }.to raise_error(ActiveRecord::RecordInvalid)
        expect { create(:template, width:  "hello", customize: true) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when NOT customizable" do
      it "doesn't validate anything" do
        expect { create(:template, title:       nil, customize: false) }.not_to raise_error
        expect { create(:template, description: nil, customize: false) }.not_to raise_error
        expect { create(:template, height:      nil, customize: false) }.not_to raise_error
        expect { create(:template, width:       nil, customize: false) }.not_to raise_error
        expect { create(:template, pdf_markup:  nil, customize: false) }.not_to raise_error
        expect { create(:template, form_markup: nil, customize: false) }.not_to raise_error
        expect { create(:template, status:      nil, customize: false) }.not_to raise_error
        expect { create(:template, height: "hello",  customize: false) }.not_to raise_error
        expect { create(:template, width:  "hello",  customize: false) }.not_to raise_error
      end
    end
  end

  describe "Concerns" do
    it_behaves_like "Status" do
      let!(:record) { template }
    end
  end

  describe "Instance Methods" do
    describe "#croppable?" do
      it "returns true when there is a blank_image" do
        expect(template.croppable?).to eq true
      end
      
      it "returns false when there is NOT a blank_image" do
        template.update_attributes!(blank_image: nil)
        expect(template.croppable?).to eq false
      end
    end
  end
end
