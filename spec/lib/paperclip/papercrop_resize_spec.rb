require 'rails_helper'

RSpec.describe Paperclip::PapercropResize, type: :class do
  let!(:image)     { create(:image, image: blank_file) }
  let!(:processor) { Paperclip::PapercropResize.new(blank_file, {}, image.image) }

  # 1x1
  def blank_file
    File.new("#{Rails.root}/spec/support/images/blank.png")
  end

  def setup
    image.strategy = :papercrop
    image.resize_height = 50
    image.resize_width = 75
  end

  it "sets target" do
    expect(processor.target).to eq image
  end

  describe "#transformation_command" do
    context "with resizing data" do
      before(:each) { setup }

      it "calculates the ImageMagick resize command" do
        result = processor.transformation_command

        expect(result).to eq ["-resize", "75x50!"]
        expect(processor.resize_height).to eq 50
        expect(processor.resize_width).to eq  75
      end
    end

    context "without resizing data" do
      it "does not crop" do
        expect(processor.transformation_command).to eq ["-auto-orient"]
      end
    end
  end
end