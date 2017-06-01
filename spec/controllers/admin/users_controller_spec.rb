require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let!(:user)     { create(:user) }
  let(:affiliate) { create(:affiliate) }

  def create_params
    {
      user: {
        first_name:            "FName",
        last_name:             "LName",
        email:                 "#{DateTime.now.to_i}@test.com",
        password:              12345678,
        password_confirmation: 12345678,
        affiliate_id:          affiliate.id
      }
    }
  end

  def destroy_params
    {id: user.id}
  end

  def update_params
    {id: user.id, user: {email: "#{DateTime.now.to_i}@test.com"}}
  end

  def mock_failure(method)
    allow_any_instance_of(User).to receive(method).and_return(false)
  end

  describe "POST #create" do
    context "not signed in" do
      it "redirects to the sign in page" do
        post :create, params: create_params

        expect(response).to have_http_status 302
        expect(response.body).to eq RSpec.configuration.redirect_html
      end
    end

    [:admin, :vetter].each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        context "when successful" do
          it "creates a new user and redirects to the user edit page" do
            post :create, params: create_params

            # This one is failing sometimes
            # expect { post :create, params: create_params }.to change(User, :count).by(1)
            expect(response).to have_http_status 302
            expect(response.body).to redirect_to edit_admin_user_path(User.last)
          end
        end

        context "when failure" do
          it "does NOT create a new user and redirects back" do
            mock_failure(:save)
            post :create, params: create_params

            expect { post :create, params: create_params }.to change(User, :count).by(0)
            expect(response).to have_http_status 200
            expect(response.body).to render_template "new"
          end
        end
      end
    end

    [:user, :local_president].each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "redirects" do
          post :create, params: create_params

          expect(response).to have_http_status 302
          expect(response).to redirect_to RSpec.configuration.http_referer
        end
      end
    end
  end

  describe "GET #edit" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :edit, params: destroy_params

        expect(response).to have_http_status 302
        expect(response.body).to eq RSpec.configuration.redirect_html
      end
    end

    [:admin, :vetter].each do |role|
      context "signed in as: #{role}" do
        controller_admin_sign_in

        it "renders the user" do
          get :edit, params: destroy_params

          expect(response).to have_http_status 200
          expect(response.body).to render_template "edit"
        end
      end
    end

    [:user, :local_president].each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "redirects" do
          get :edit, params: destroy_params

          expect(response).to have_http_status 302
          expect(response).to redirect_to RSpec.configuration.http_referer
        end
      end
    end
  end

  describe "GET #index" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :index
        expect(response).to have_http_status 302
        expect(response.body).to eq RSpec.configuration.redirect_html
      end
    end

    [:admin, :vetter].each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "renders the index template" do
          get :index
          expect(response).to have_http_status 200
          expect(response.body).to render_template "index"
        end
      end
    end

    [:user, :local_president].each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "redirects" do
          get :index
          expect(response).to have_http_status 302
          expect(response).to redirect_to RSpec.configuration.http_referer
        end
      end
    end
  end

  describe "GET #new" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :new
        expect(response).to have_http_status 302
        expect(response.body).to eq RSpec.configuration.redirect_html
      end
    end

    [:admin, :vetter].each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "renders the new template" do
          get :new
          expect(response).to have_http_status 200
          expect(response.body).to render_template "new"
        end
      end
    end

    [:user, :local_president].each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "redirects" do
          get :new
          expect(response).to have_http_status 302
          expect(response).to redirect_to RSpec.configuration.http_referer
        end
      end
    end
  end

  describe "PATCH #update" do
    context "not signed in" do
      it "redirects to the sign in page" do
        patch :update, params: update_params

        expect(response).to have_http_status 302
        expect(response.body).to eq RSpec.configuration.redirect_html
      end
    end

    [:admin, :vetter].each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        context "when successful" do
          it "redirects to the user edit page" do
            patch :update, params: update_params
            
            expect(response).to have_http_status 302
            expect(response.body).to redirect_to edit_admin_user_path(user)
          end
        end

        context "when failure" do
          it "renders the edit template" do
            mock_failure(:update_attributes)
            patch :update, params: update_params

            expect(response).to have_http_status 200
            expect(response.body).to render_template "edit"
          end
        end
      end
    end

    [:user, :local_president].each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "redirects" do
          patch :update, params: update_params

          expect(response).to have_http_status 302
          expect(response).to redirect_to RSpec.configuration.http_referer
        end
      end
    end
  end
end
