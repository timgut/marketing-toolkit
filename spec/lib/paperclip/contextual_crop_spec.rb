require 'rails_helper'

RSpec.describe Paperclip::ContextualCrop, type: :class do
  let!(:image)     { create(:image) }
  let!(:template)  { create(:template) }
  let!(:file)      { File.new("#{Rails.root}/spec/support/images/1260x573.jpg") }
  let!(:processor) { Paperclip::ContextualCrop.new(file, {}, image.image) }

  def set_context
    image.context = template
  end

  def set_xy(x,y)
    image.pos_x = x
    image.pos_y = y
  end

  it "sets target" do
    expect(processor.target).to eq image
  end

  it "sets context" do
    set_context
    expect(processor.context).to eq template
  end

  context "with cropping data" do
    before(:each) { set_context }

    describe "with a negative pos_x" do
      it "uses the absolute value" do
        set_xy(-100, 100)
        expect(processor.transformation_command).to eq ["-crop", "600x761+100+100"]
      end
    end

    describe "with a negative pos_y" do
      it "uses the absolute value" do
        set_xy(100, -200)
        expect(processor.transformation_command).to eq ["-crop", "600x761+100+200"]
      end
    end
  end

  context "without cropping data" do
    it "does not crop" do
      expect(processor.transformation_command).to eq ["-auto-orient"]
    end
  end
end