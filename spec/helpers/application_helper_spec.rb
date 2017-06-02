require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#changed_document_message" do
    it "returns a string" do
      expect(helper.changed_document_message).to be_a String
    end
  end

  describe "#changed_document_message" do
    let!(:template) { create(:template) }

    it "returns a string" do
      expect(helper.dimensions(template)).to be_a String
    end
  end
  
  describe "#download_link" do
    let!(:document) { create(:document) }

    context "with a PDF" do
      it "returns a URL" do
        allow(document).to receive(:pdf_file_name).and_return("my_pdf")
        expect(helper.download_link(document)).to be_a String
      end
    end

    context "without a PDF" do
      it "returns a URL" do
        expect(helper.download_link(document)).to be_a String
      end
    end
  end

  # UNCOMMENT AND MAKE THESE PASS WHEN #1567 IS LAUNCHED.
  #
  # describe "#thumbnail_url" do
  #   let!(:document) { create(:document) }

  #   context "with a thumbnail" do
  #     it "returns a URL" do
  #       allow(document).to receive(:thumbnail_file_name).and_return("my_thumbnail")
  #       expect(helper.thumbnail_url(document)).to be_a String
  #     end
  #   end

  #   context "without a PDF" do
  #     it "returns a URL" do
  #       expect(helper.thumbnail_url(document)).to be_a String
  #     end
  #   end
  # end
end
