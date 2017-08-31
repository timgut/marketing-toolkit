require 'rails_helper'

RSpec.describe Paperclip::PapercropNormalize, type: :class do
  let!(:image) { create(:image, image: blank_file) }

  # 1x1
  def blank_file
    File.new("#{Rails.root}/spec/support/images/blank.png")
  end

  # 2500x2000
  def landscape_file
    File.new("#{Rails.root}/spec/support/images/landscape-big.png")
  end

  # 2000x2500
  def portrait_file
    File.new("#{Rails.root}/spec/support/images/portrait-big.png")
  end

  def setup(new_image)
    image.image = new_image
    image.save!
    image.strategy = :papercrop
    image.reset_commands
  end

  describe "Helper Methods" do
    let!(:processor) { Paperclip::PapercropNormalize.new(blank_file, {}, image.image) }

    it "sets target" do
      expect(processor.target).to eq image
    end
  end

  describe "#transformation_command" do
    context "when the image is SMALLER than the max size" do
      let!(:processor) { Paperclip::PapercropNormalize.new(blank_file, {}, image.image) }

      it "does nothing" do
        expect(processor.transformation_command).to eq ["-auto-orient"]
      end
    end

    context "when the image is LARGER than the max size" do
      context "Landscape" do
        before(:each){ setup(landscape_file) }

        let!(:image)     { create(:image, image: landscape_file) }
        let!(:processor) { Paperclip::PapercropNormalize.new(landscape_file, {}, image.image) }

        it "calculates the ImageMagick resize command" do
          result = processor.transformation_command

          expect(processor.transformation_command).to eq ["-resize", "1500x1200"]

          # 1500.0 / 2500.0 = 0.6
          expect(processor.aspect).to eq 0.6

          # (2000 * 0.6).ceil
          expect(processor.new_height).to eq 1200

          # (2500 * 0.6).ceil
          expect(processor.new_width).to eq 1500
        end
      end

      context "Portrait" do
        before(:each){ setup(portrait_file) }

        let!(:image)     { create(:image, image: portrait_file) }
        let!(:processor) { Paperclip::PapercropNormalize.new(portrait_file, {}, image.image) }

        it "calculates the ImageMagick resize command" do
          result = processor.transformation_command

          expect(processor.transformation_command).to eq ["-resize", "1200x1500"]

          # 1500.0 / 2500.0 = 0.6
          expect(processor.aspect).to eq 0.6

          # (2000 * 0.6).ceil
          expect(processor.new_width).to eq 1200

          # (2500 * 0.6).ceil
          expect(processor.new_height).to eq 1500
        end
      end
    end
  end
end