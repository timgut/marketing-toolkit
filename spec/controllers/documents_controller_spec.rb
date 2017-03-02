require 'rails_helper'

# These specs were written when this was called "FlyersController". They probably won't pass until they are cleaned up.
RSpec.describe DocumentsController, type: :controller do
  controller_user_sign_in

  let!(:template) { create(:template) }
  let!(:flyer)    { create(:flyer, template: template, folder: current_user.root_flyer_folder) }

  def create_params(additional_params = {})
    {
      params: {
        flyer: {
          title:       "New Flyer",
          description: "This is my new flyer",
          status:      "publish",
          template_id: template.id,
          folder_id:   current_user.root_flyer_folder.id
        },
        data: {
          key1: "value1",
          key2: "value2",
          key3: "value3"
        }
      }.merge(additional_params)
    }
  end

  def show_params(additional_params = {})
    {
      params: {
        id: flyer.id
      }.merge(additional_params)
    }
  end

  describe "POST create" do
    it "creates a new Flyer" do
      expect { post :create, create_params}.to change(Flyer, :count).by(1)
    end

    it "creates a new FlyerUser" do
      expect { post :create, create_params}.to change(FlyerUser, :count).by(1)
    end

    it "creates a Datum record for each params[:data]" do
      expect { post :create, create_params}.to change(Datum, :count).by(3)
      expect(Datum.find_by(flyer_id: Flyer.last.id, key: "key1", value: "value1")).to be_a(Datum)
    end
  end

  describe "GET generate" do
    it "forces .pdf as the format" do
      expect(controller).to receive(:force_format).with(:pdf)
      get :generate, show_params
    end

    # Not sure how to do this yet.
    xit "creates a PDF" do
      get :generate, show_params
      expect(flyer.pdf).to be_a_pdf
    end
  end
end
