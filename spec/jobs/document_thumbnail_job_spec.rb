require 'rails_helper'

describe DocumentThumbnailJob, type: :job do
  let!(:document) { create(:document) }
  let!(:job)      { DocumentThumbnailJob.new }

  before(:each) do
    # Speed up processing time by stubbing a blank PDF.
    allow(document).to receive(:local_pdf_path).and_return(Rails.root.join("spec", "support", "images", "blank.pdf").to_s)
  end

  describe "Instance Methods" do
    describe "#perform" do
      it "it creates a thumbnail for the document" do
        job.perform(document)
        expect(document.reload.thumbnail_file_name).not_to eq nil
      end
    end
  end
end