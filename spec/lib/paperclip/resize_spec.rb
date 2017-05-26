require 'rails_helper'

RSpec.describe Paperclip::Resize, type: :class do
  let!(:image)     { create(:image, image: landscape_file) }
  let!(:template)  { create(:template, blank_image: blank_file) }
  let!(:processor) { Paperclip::Resize.new(landscape_file, {}, image.image) }

  # 1260x573
  def landscape_file
    File.new("#{Rails.root}/spec/support/images/landscape.jpg")
  end

  # 479x720
  def portrait_file
    File.new("#{Rails.root}/spec/support/images/portrait.jpg")
  end

  # 600x761
  def blank_file
    File.new("#{Rails.root}/spec/support/images/blank.jpg")
  end

  def setup_resize
    image.context = template
    image.resize  = true
  end

  it "sets target" do
    expect(processor.target).to eq image
  end

  it "sets context" do
    set_context
    expect(processor.context).to eq template
  end

  describe "#transformation_command" do
    before(:each) { setup_resize }

    context "with resizing data" do
      context "landscape" do
        it "calculates the ImageMagick resize command" do
          result = processor.transformation_command
          expect(result).to eq ["-resize", "2009x914^"]

          # 761 * 1.2
          expect(processor.new_height).to eq 914
          
          # ( 1260 * 914 ) / 573
          expect(processor.new_width).to eq  2009
        end
      end

      context "portrait" do
        it "calculates the ImageMagick resize command" do
          processor = Paperclip::Resize.new(portrait_file, {}, create(:image, image: portrait_file))
          result    = processor.transformation_command

          expect(result).to eq []

          expect(processor.new_width).to eq  2009

          expect(processor.new_height).to eq 914
        end
      end  
    end

    context "without resizing data" do
      it "does not crop" do
        expect(processor.transformation_command).to eq ["-auto-orient"]
      end
    end
  end
end
