require 'rails_helper'

RSpec.describe Admin::TemplatesController, type: :controller do
  let!(:template) { create(:template) }
  let(:campaign) { create(:campaign) }
  let(:category) { create(:category) }

  def create_params
    { 
      template: {
        title:       "My template",
        description: "Lorem ipsum dolar amet set",
        status:      :publish,
        height:      11,
        width:       8.5,
        pdf_markup:  "PDF markup",
        form_markup: "Form Markup",
        category_id: category.id,
        orientation: :portrait,
        customize:   true
      }
    }
  end

  def destroy_params
    {id: template.id}
  end

  def update_params
    {id: template.id, template: {title: "New Title"}}
  end

  def mock_failure(method)
    allow_any_instance_of(Template).to receive(method).and_return(false)
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
        it "creates a new template and redirects to the edit page" do
          post :create, params: create_params

          expect { post :create, params: create_params }.to change(Template, :count).by(1)
          expect(response).to have_http_status 302
          expect(response.body).to redirect_to edit_admin_template_path(Template.last)
        end
      end

      context "when failure" do
        it "does NOT create a new template and renders the form" do
          mock_failure(:save)
          post :create, params: create_params

          expect { post :create, params: create_params }.to change(Template, :count).by(0)
          expect(response).to have_http_status 200
          expect(response.body).to render_template "new"
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
        it "sets the status to 'trash' and redirects to the admin template index" do
          delete :destroy, params: destroy_params
          
          expect(template.reload.status).to eq "trash"
          expect(response).to have_http_status 302
          expect(response).to redirect_to RSpec.configuration.http_referer
        end
      end

      context "when failure" do
        it "redirects" do
          mock_failure(:update_attributes)
          delete :destroy, params: destroy_params

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

      it "renders the template" do
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

  describe "GET #new" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :new
        expect(response).to have_http_status 302
        expect(response.body).to eq RSpec.configuration.redirect_html
      end
    end

    context "signed in as: admin" do
      controller_admin_sign_in

      it "renders the index template" do
        get :new
        expect(response).to have_http_status 200
        expect(response.body).to render_template "new"
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

      context "html" do
        context "when successful" do
          it "redirects to the template edit page" do
            patch :update, params: update_params
            
            expect(response).to have_http_status 302
            expect(response.body).to redirect_to edit_admin_template_path(template)
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

      context "json" do
        context "when successful" do
          it "renders no content" do
            patch :update, params: update_params.merge({format: :json})
            
            expect(response).to have_http_status 204
            expect(response.body).to eq ""
          end
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
