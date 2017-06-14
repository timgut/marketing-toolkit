require 'rails_helper'

RSpec.describe ImagesController, type: :controller do
  let!(:image)   { create(:image) }
  let(:template) { create(:template) }

  def create_params
    {
      image: {
        file:        File.new("#{Rails.root}/spec/support/images/blank.png"),
        creator_id:  current_user&.id
      }
    }
  end

  def destroy_params
    { id: image.id }
  end

  def new_params
    { template_id: template.id }
  end

  def update_params(format:, strategy:)
    { 
      id: image.id,
      format: format,
      image: {
        crop_data:   "crop data",
        template_id: template.id,
        strategy:    strategy
      }
    }
  end

  def contextual_crop_params
    { 
      id: image.id,
      image: {
        template_id: template.id,
        strategy:    :contextual_crop
      }
    }
  end

  def papercrop_params
    {
      id: image.id, 
      resize_height: 75, 
      resize_width: 100,
      image: {
        strategy: :papercrop
      }
    }
  end

  def mock_failure(method)
    allow_any_instance_of(Image).to receive(method).and_return(false)
  end

  def own_image
    image.update_attributes!(creator_id: current_user.id)
  end

  def delete_images
    Image.all.destroy_all # Otherwise a duplicate filename error will be raised
  end

  describe "Concerns" do
    it_behaves_like "Trashable" do
      let!(:record) { image }
    end
  end

  describe "GET #choose" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :choose, params: destroy_params
        expect(response).to have_http_status 302
        expect(response).to redirect_to new_user_session_path
      end
    end

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "renders the choose template" do
          own_image
          get :choose, params: destroy_params

          expect(response).to have_http_status 200
          expect(response).to render_template "choose"
        end
      end
    end
  end

  describe "POST #create" do
    context "not signed in" do
      it "redirects to the sign in page" do
        post :create, params: {}
        expect(response).to have_http_status 302
        expect(response.body).to redirect_to new_user_session_path
      end
    end

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        context "html" do
          context "when successful" do
            it "creates new records and redirects to the images index" do
              expect { post :create, params: create_params.merge({format: :html}) }.to change(Image, :count).by(1)
              delete_images

              expect { post :create, params: create_params.merge({format: :html}) }.to change(ImageUser, :count).by(1)
              delete_images
  
              post :create, params: create_params.merge({format: :html})
              expect(response).to have_http_status 302
              expect(response).to redirect_to image_path(Image.last)
            end
          end
          
          context "when failure" do
            it "renders the new template" do
              mock_failure(:save)

              expect { post :create, params: create_params.merge({format: :html}) }.to change(Image, :count).by(0)
              delete_images
              
              expect { post :create, params: create_params.merge({format: :html}) }.to change(ImageUser, :count).by(0)
              delete_images

              post :create, params: create_params.merge({format: :html})
              expect(response).to have_http_status 200
              expect(response).to render_template "new"
            end
          end
        end

        context "json" do
          context "when successful" do
            it "creates new records and renders JSON" do
              expect { post :create, params: create_params.merge({format: :json}) }.to change(Image, :count).by(1)
              delete_images

              expect { post :create, params: create_params.merge({format: :json}) }.to change(ImageUser, :count).by(1)
              delete_images

              post :create, params: create_params.merge({format: :json})
              expect(response).to have_http_status 200
              ["id", "url", "cropped_url", "file_name"].each do |key|
                expect(JSON.parse(response.body).keys).to include key
              end
            end
          end
          
          context "when failure" do
            it "renders the error" do
              mock_failure(:save)

              expect { post :create, params: create_params.merge({format: :json}) }.to change(Image, :count).by(0)
              delete_images

              expect { post :create, params: create_params.merge({format: :json}) }.to change(ImageUser, :count).by(0)
              delete_images

              post :create, params: create_params.merge({format: :json})
              expect(response).to have_http_status 403
              expect(response.body).to eq image.errors.full_messages.to_sentence
            end
          end
        end
      end
    end
  end

  describe "GET #contextual_crop" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :contextual_crop, params: contextual_crop_params
        expect(response).to have_http_status 302
        expect(response).to redirect_to new_user_session_path
      end
    end

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "renders the choose template" do
          own_image
          get :contextual_crop, params: contextual_crop_params

          expect(response).to have_http_status 200
          expect(response).to render_template "contextual_crop"
        end
      end
    end
  end

  describe "GET #papercrop" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :papercrop, params: papercrop_params
        expect(response).to have_http_status 302
        expect(response).to redirect_to new_user_session_path
      end
    end

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "renders the choose template" do
          own_image
          get :papercrop, params: papercrop_params

          expect(response).to have_http_status 200
          expect(response).to render_template "papercrop"
        end
      end
    end
  end

  describe "GET #edit" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :edit, params: destroy_params
        expect(response).to have_http_status 302
        expect(response).to redirect_to new_user_session_path
      end
    end

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "renders the edit template" do
          own_image
          get :edit, params: destroy_params

          expect(response).to have_http_status 200
          expect(response).to render_template "edit"
        end
      end
    end
  end

  [:index, :recent, :shared].each do |action|
    describe "GET ##{action}" do
      context "not signed in" do
        it "redirects to the sign in page" do
          get action
          expect(response).to have_http_status 302
          expect(response).to redirect_to new_user_session_path
        end
      end

      RSpec.configuration.user_roles.each do |role|
        context "signed in as: #{role}" do
          __send__("controller_#{role}_sign_in".to_sym)

          it "renders the index template" do
            own_image
            get action

            expect(response).to have_http_status 200
            expect(response).to render_template "index"
          end
        end
      end
    end
  end

  describe "GET #new" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :new
        expect(response).to have_http_status 302
        expect(response).to redirect_to new_user_session_path
      end
    end

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "renders the new template" do
          own_image
          get :new

          expect(response).to have_http_status 200
          expect(response).to render_template "new"
        end
      end
    end
  end

  describe "GET #show" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :show, params: destroy_params
        expect(response).to have_http_status 302
        expect(response).to redirect_to new_user_session_path
      end
    end

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "renders the show template" do
          own_image
          get :show, params: destroy_params

          expect(response).to have_http_status 200
          expect(response).to render_template "show"
        end
      end
    end
  end

  describe "PATCH #update" do
    context "not signed in" do
      it "redirects to the sign in page" do
        post :create, params: {}
        expect(response).to have_http_status 302
        expect(response.body).to redirect_to new_user_session_path
      end
    end

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        [:papercrop, :contextual_crop].each do |strategy|
          context "with #{strategy} strategy" do
            context "html" do
              context "when successful" do
                it "updates the image and redirects to the images index" do
                  own_image
                  patch :update, params: update_params(format: :html, strategy: strategy)

                  expect(response).to have_http_status 302
                  expect(response).to redirect_to images_path
                end
              end
              
              context "when failure" do
                it "renders the edit template" do
                  own_image
                  mock_failure(:update_attributes)
                  patch :update, params: update_params(format: :html, strategy: strategy)

                  expect(response).to have_http_status 200
                  expect(response).to render_template "edit"
                end
              end
            end

            context "json" do
              context "when successful" do
                it "updates the image and renders JSON" do
                  own_image
                  patch :update, params: update_params(format: :json, strategy: strategy)
                  
                  expect(response).to have_http_status 200
                  ["id", "url", "cropped_url", "file_name"].each do |key|
                    expect(JSON.parse(response.body).keys).to include key
                  end
                end
              end
              
              context "when failure" do
                it "renders the error" do
                  own_image
                  mock_failure(:update_attributes)
                  patch :update, params: update_params(format: :json, strategy: strategy)

                  expect(response).to have_http_status 403
                  expect(response.body).to eq image.errors.full_messages.to_sentence
                end
              end
            end
          end
        end
      end
    end
  end
end
