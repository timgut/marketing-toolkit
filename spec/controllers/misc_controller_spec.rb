require 'rails_helper'

RSpec.describe MiscController, type: :controller do
  describe "GET #intro" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :intro
        expect(response).to have_http_status(302)
        expect(response.body).to eq RSpec.configuration.redirect_html
      end
    end

    context "signed in as a User" do
      controller_user_sign_in

      it "renders the intro template" do
        get :intro
        expect(response).to have_http_status(200)
        expect(response).to render_template("intro")
      end
    end
  end
end
