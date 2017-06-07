require 'rails_helper'

RSpec.describe Admin::MiscController, type: :controller do
  describe "GET #home" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :home
        expect(response).to have_http_status 302
        expect(response.body).to eq RSpec.configuration.redirect_html
      end
    end

    context "signed in as: admin" do
      controller_admin_sign_in

      it "renders the home template" do
        get :home
        expect(response).to have_http_status 200
        expect(response.body).to render_template "home"
      end
    end

    RSpec.configuration.non_admins.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "redirects" do
          get :home
          expect(response).to have_http_status 302
          expect(response).to redirect_to RSpec.configuration.http_referer
        end
      end
    end
  end
end