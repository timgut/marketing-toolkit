require 'rails_helper'

RSpec.describe Admin::CategoriesController, type: :controller do
  let!(:category) { create(:category) }

  def create_params
    {category: {title: "My category"}}
  end

  def destroy_params
    {id: category.id}
  end

  def update_params
    {id: category.id, category: {title: "New Title"}}
  end

  def mock_failure(method)
    allow_any_instance_of(Category).to receive(method).and_return(false)
  end

  describe "POST #create" do
    context "not signed in" do
      it "redirects to the sign in page" do
        post :create, params: create_params

        expect(response).to have_http_status 302
        expect(response.body).to eq RSpec.configuration.redirect_html
      end
    end

    context "signed in as: admin" do
      controller_admin_sign_in

      context "when successful" do
        it "creates a new category and redirects to the admin category index" do
          post :create, params: create_params

          expect { post :create, params: create_params }.to change(Category, :count).by(1)
          expect(response).to have_http_status 302
          expect(response.body).to redirect_to admin_categories_path
        end
      end

      context "when failure" do
        it "does NOT create a new category and redirects back" do
          mock_failure(:save)
          post :create, params: create_params

          expect { post :create, params: create_params }.to change(Category, :count).by(0)
          expect(response).to have_http_status 302
          expect(response.body).to redirect_to RSpec.configuration.http_referer
        end
      end
    end

    RSpec.configuration.non_admins.each do |role|
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

  describe "DELETE #destroy" do
    context "not signed in" do
      it "redirects to the sign in page" do
        delete :destroy, params: destroy_params

        expect(response).to have_http_status 302
        expect(response.body).to eq RSpec.configuration.redirect_html
      end
    end

    context "signed in as: admin" do
      controller_admin_sign_in

      context "when successful" do
        it "deletes the category and redirects to the admin category index" do
          delete :destroy, params: destroy_params
          id = create(:category).id

          expect { delete :destroy, params: {id: id } }.to change(Category, :count).by(-1)
          expect(response).to have_http_status 302
          expect(response.body).to redirect_to admin_categories_path
        end
      end

      context "when failure" do
        it "does NOT create a new category and redirects back" do
          mock_failure(:destroy)
          delete :destroy, params: destroy_params

          expect { delete :destroy, params: destroy_params }.to change(Category, :count).by(0)
          expect(response).to have_http_status 302
          expect(response.body).to redirect_to RSpec.configuration.http_referer
        end
      end
    end

    RSpec.configuration.non_admins.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "redirects" do
          delete :destroy, params: destroy_params

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

    context "signed in as: admin" do
      controller_admin_sign_in

      it "renders the category" do
        get :edit, params: destroy_params

        expect(response).to have_http_status 200
        expect(response.body).to render_template "edit"
      end
    end

    RSpec.configuration.non_admins.each do |role|
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

    context "signed in as: admin" do
      controller_admin_sign_in

      it "renders the index template" do
        get :index
        expect(response).to have_http_status 200
        expect(response.body).to render_template "index"
      end
    end

    RSpec.configuration.non_admins.each do |role|
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

  describe "PATCH #update" do
    context "not signed in" do
      it "redirects to the sign in page" do
        patch :update, params: update_params

        expect(response).to have_http_status 302
        expect(response.body).to eq RSpec.configuration.redirect_html
      end
    end

    context "signed in as: admin" do
      controller_admin_sign_in

      context "when successful" do
        it "redirects to the category edit page" do
          patch :update, params: update_params
          
          expect(response).to have_http_status 302
          expect(response.body).to redirect_to edit_admin_category_path(category)
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

    RSpec.configuration.non_admins.each do |role|
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
