require 'rails_helper'

RSpec.describe Admin::CampaignsController, type: :controller do
  let!(:campaign)   { create(:campaign) }
  
  def non_admins
    @non_admins ||= RSpec.configuration.user_roles - [:admin]
  end

  describe "GET #index" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :index
        expect(response).to have_http_status(302)
        expect(response.body).to eq RSpec.configuration.redirect_html
      end
    end

    context "signed in as: admin" do
      controller_admin_sign_in

      it "renders the index template" do
        get :index
        expect(response).to have_http_status(200)
        expect(response.body).to render_template("index")
      end
    end

    (RSpec.configuration.user_roles - [:admin]).each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "redirects" do
          get :index
          expect(response).to have_http_status(302)
        end
      end
    end
  end
end
