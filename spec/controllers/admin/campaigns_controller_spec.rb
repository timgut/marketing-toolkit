require 'rails_helper'

RSpec.describe Admin::CampaignsController, type: :controller do
  let!(:campaign) { create(:campaign) }

  def create_params
    {campaign: {title: "My campaign", description: "Lorem ipsum dolar amet set", status: :publish, parent_id: nil}}
  end

  def destroy_params
    {id: campaign.id}
  end

  def update_params
    {id: campaign.id, campaign: {title: "New Title"}}
  end

  def mock_failure(method)
    allow_any_instance_of(Campaign).to receive(method).and_return(false)
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
        it "creates a new campaign and redirects to the admin campaign index" do
          post :create, params: create_params

          expect { post :create, params: create_params }.to change(Campaign, :count).by(1)
          expect(response).to have_http_status 302
          expect(response.body).to redirect_to admin_campaigns_path
        end
      end

      context "when failure" do
        it "does NOT create a new campaign and redirects back" do
          mock_failure(:save)
          post :create, params: create_params

          expect { post :create, params: create_params }.to change(Campaign, :count).by(0)
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
        it "deletes the campaign and redirects to the admin campaign index" do
          delete :destroy, params: destroy_params
          id = create(:campaign).id

          expect { delete :destroy, params: {id: id } }.to change(Campaign, :count).by(-1)
          expect(response).to have_http_status 302
          expect(response.body).to redirect_to admin_campaigns_path
        end
      end

      context "when failure" do
        it "does NOT create a new campaign and redirects back" do
          mock_failure(:destroy)
          delete :destroy, params: destroy_params

          expect { delete :destroy, params: destroy_params }.to change(Campaign, :count).by(0)
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

      it "renders the campaign" do
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
        it "redirects to the campaign edit page" do
          patch :update, params: update_params
          
          expect(response).to have_http_status 302
          expect(response.body).to redirect_to edit_admin_campaign_path(campaign)
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
