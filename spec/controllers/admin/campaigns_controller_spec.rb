require 'rails_helper'

RSpec.describe Admin::CampaignsController, type: :controller do
  let!(:campaign)   { create(:campaign) }
  let!(:non_admins) { RSpec.configuration.user_roles - [:user] }

  describe "GET #index" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :index
        expect(response).to have_http_status(302)
        expect(response.body).to eq RSpec.configuration.redirect_html
      end
    end

    context "signed in as a User" do
      controller_user_sign_in

      it "redirects to the sign in page" do
        get :index
        expect(response).to have_http_status(302)
        expect(response.body).to eq RSpec.configuration.redirect_html
      end
    end

    context "signed in as an Admin" do
      controller_admin_sign_in

      it "renders the intro template" do
        get :index
        expect(response).to have_http_status(200)
        expect(response).to render_template("index")
      end
    end
  end
end
