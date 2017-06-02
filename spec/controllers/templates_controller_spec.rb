require 'rails_helper'

RSpec.describe TemplatesController, type: :controller do
  let!(:template) { create(:template) }

  describe "GET #index" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :index
        expect(response).to have_http_status(302)
        expect(response).to redirect_to new_user_session_path
      end
    end

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "renders the index template" do
          get :index
          expect(response).to have_http_status 200
          expect(response).to render_template "index"
        end
      end
    end
  end

  describe "GET #show" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :show, params: {id: template.id}
        expect(response).to have_http_status 302
        expect(response.body).to redirect_to new_user_session_path
      end
    end

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "renders the show template" do
          get :show, params: {id: template.id}
          expect(response).to have_http_status 200
          expect(response).to render_template "show"
        end
      end
    end
  end
end
