require 'rails_helper'

RSpec.describe Image, type: :model do
  let!(:user)  { create(:user) }
  let!(:image) { create(:image, creator_id: user.id) }

  def set_crop_data
    image.update_attributes(crop_data: {
      crop:   "-crop 612x791+140+167",
      resize: "-resize 1430x950^",
      drag:   {x: "-140", y: "-167"}
    })
  end

  describe "Paperclip" do
    describe "image" do
      it "has an attachment" do
        expect(Image).to have_attached_file(:image)
      end

      it "validates the content_type is an image" do
        expect(Image).to validate_attachment_content_type(:image).
          allowing("image/png", "image/gif", "image/jpg", "image/jpeg").
          rejecting("application/pdf")
      end
    end
  end

  describe "Associations" do
    it "belongs_to creator" do
      expect(image).to respond_to(:creator)
    end
    
    it "has_and_belongs_to_many users" do
      expect(image).to respond_to(:users)
    end
    
    it "has_many :image_users" do
      expect(image).to respond_to(:image_users)
    end
  end

  describe "Validations" do
    it "validates_uniqueness_of image_file_name scoped by user" do
      new_user  = create(:user)

      expect { create(:image, creator_id: user.id) }.to raise_error(ActiveRecord::RecordInvalid)      
      expect { create(:image, creator_id: new_user.id) }.not_to raise_error
    end
  end

  describe "Scopes" do
    describe ".recent" do
      it "displays images from the last 2 weeks" do
        image.update_attributes!(created_at: DateTime.now - 1.month)
        expect(Image.recent(user)).not_to include image

        image.update_attributes!(created_at: DateTime.now - 1.week)
        expect(Image.recent(user)).to include image
      end
    end
  end

  describe "Concerns" do
    it_behaves_like "Status" do
      let!(:record) { image }
    end
  end

  describe "Class Methods" do
    describe ".find_by_url" do
      it "returns an image when given a valid URL" do
        expect(Image.find_by_url(image.image.url)).to eq image
      end

      it "returns false when no image is found at the URL" do
        expect(Image.find_by_url("http://my.fake/image.jpg")).to eq false
      end
    end
  end

  describe "Instance Methods" do
    describe "#cropping?" do
      it "returns true when context, pos_x, and pos_y are set" do
        context = create(:template)
        image.context = context
        image.pos_x   = 100
        image.pos_y   = 50

        expect(image.cropping?).to eq true
      end

      it "returns false when context, pos_x, and pos_y are NOT set" do
        expect(image.cropping?).to eq false
      end
    end

    describe "#orientation" do
      it "returns landscape" do
        image2 = create(:image, image: File.new("#{Rails.root}/spec/support/images/landscape.jpg"))
        expect(image2.orientation).to eq :landscape
      end
      
      it "returns portrait" do
        image2 = create(:image, image: File.new("#{Rails.root}/spec/support/images/portrait.jpg"))
        expect(image2.orientation).to eq :portrait
      end
    end

    describe "#resizing?" do
      it "returns true when resize is set" do
        image.resize = true
        expect(image.resizing?).to eq true
      end
      
      it "returns false when resize is NOT set" do
        expect(image.resizing?).to eq false
      end
    end

    describe "#reset_crop_data" do
      it "sets crop_data to {}" do
        set_crop_data
        image.reset_crop_data
        expect(image.crop_data.empty?).to eq true
      end
    end

    describe "#set_crop_data!" do
      it "persists the crop_data" do
        image.crop_cmd   = "-crop 612x791+140+167"
        image.resize_cmd = "-resize 1430x950^"
        image.pos_x      = "-140"
        image.pos_y      = "-167"

        image.set_crop_data!
        image.reload

        expect(image.crop_data).to eq({
          crop: "-crop 612x791+140+167", resize: "-resize 1430x950^", drag: {x: "-140", y: "-167"}
        })
      end
    end
  end
end
