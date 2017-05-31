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

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "renders the intro template" do
          get :intro
          expect(response).to have_http_status(200)
          expect(response).to render_template("intro")
        end
      end
    end
  end
end
