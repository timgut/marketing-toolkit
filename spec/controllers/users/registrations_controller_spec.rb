require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  let!(:user) { create(:user) }

  def edit_params
    { id: user.id }
  end

  def update_password_params
    {
      id: user.id,
      user: {
        password: "12345678",
        password_confirmation: "12345678"
      }
    }
  end

  def mock_failure(method)
    allow_any_instance_of(User).to receive(method).and_return(false)
  end

  describe "GET #edit" do
    context "not signed in" do
      it "raises an error" do
        expect { get :edit, params: edit_params }.to raise_error(NoMethodError)
      end
    end

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "renders the choose template" do
          get :edit, params: edit_params

          expect(response).to have_http_status 200
          expect(response).to render_template "edit"
        end
      end
    end
  end

  describe "GET #password" do
    context "not signed in" do
      it "raises an error" do
        expect { get :password, params: edit_params }.to raise_error(AbstractController::ActionNotFound)
      end
    end

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "renders the choose template" do
          get :password, params: edit_params

          expect(response).to have_http_status 200
          expect(response).to render_template "password"
        end
      end
    end
  end

  describe "PUT #update_password" do
    context "not signed in" do
      it "raises an error" do
        expect { put :update_password, params: update_password_params }.to raise_error(AbstractController::ActionNotFound)
      end
    end

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        context "when the passwords match" do
          context "when successful" do
            it "redirects to profile_path" do
              put :update_password, params: update_password_params

              expect(response).to have_http_status 302
              expect(response).to redirect_to profile_path
            end
          end

          context "when failure" do
            it "redirects to profile_path" do
              mock_failure(:update)
              put :update_password, params: update_password_params

              expect(response).to have_http_status 302
              expect(response).to redirect_to profile_path
            end
          end
        end

        context "when the passwords don't match" do
          it "redirects to profile_path" do
            put :update_password, params: update_password_params.merge({user: {password: "blah"}})

            expect(response).to have_http_status 302
            expect(response).to redirect_to profile_path
          end
        end
      end
    end
  end
end