require 'rails_helper'

RSpec.shared_examples "Trashable" do
  def mock_failure(method)
    allow_any_instance_of(record.class).to receive(method).and_return(false)
  end

  def own_record
    record.update_attributes!(creator_id: current_user.id)
  end

  def record_to_s
    case record
    when Document
      "Document"
    when Image
      "Image"
    end
  end

  def records_path
    case record
    when Document
      documents_path
    when Image
      images_path
    end
  end

  describe "DELETE #destroy" do
    context "not signed in" do
      it "redirects to the sign in page" do
        delete :destroy, params: destroy_params

        expect(response).to have_http_status 302
        expect(response).to redirect_to RSpec.configuration.http_referer
      end
    end

    RSpec.configuration.user_roles.each do |role|
      __send__("controller_#{role}_sign_in".to_sym)

      context "signed in as: #{role}" do
        context "when the record is in the trash" do
          context "when successful" do
            it "redirects to the records index" do
              own_record
              record.update_attributes(status: -2)
              delete :destroy, params: destroy_params

              expect(response).to have_http_status 302
              expect(response).to redirect_to "#{records_path}?notice=#{record_to_s}+destroyed%21"
            end
          end

          context "when failure" do
            it "redirects to the records index" do
              own_record
              record.update_attributes(status: -2)
              mock_failure(:destroy)
              delete :destroy, params: destroy_params

              expect(response).to have_http_status 302
              expect(response).to redirect_to "#{records_path}?alert=Cannot+destroy+#{record_to_s.downcase}.+Please+try+again."
            end
          end
        end
      end

      context "when the record is NOT in the trash" do
        it "redirects to the records index" do
          own_record
          delete :destroy, params: destroy_params

          expect(response).to have_http_status 302
          expect(response).to redirect_to "#{records_path}?alert=This+#{record_to_s.downcase}+must+be+placed+in+the+trash+before+it+can+be+destroyed."
        end
      end
    end
  end

  describe "PATCH #restore" do
    context "not signed in" do
      it "redirects to the sign in page" do
        patch :restore, params: destroy_params

        expect(response).to have_http_status 302
        expect(response).to redirect_to RSpec.configuration.http_referer
      end
    end

    RSpec.configuration.user_roles.each do |role|
      __send__("controller_#{role}_sign_in".to_sym)

      context "signed in as: #{role}" do
        context "when successful" do
          it "redirects to the records index" do
            own_record
            patch :restore, params: destroy_params

            expect(response).to have_http_status 302
            expect(response).to redirect_to "#{records_path}?notice=#{record_to_s}+restored%21"
          end
        end

        context "when failure" do
          it "redirects to the records index" do
            own_record
            mock_failure(:update_attributes)
            patch :restore, params: destroy_params

            expect(response).to have_http_status 302
            expect(response).to redirect_to "#{records_path}?alert=Cannot+restore+#{record_to_s.downcase}.+Please+try+again."
          end
        end
      end
    end
  end

  describe "PATCH #trash" do
    context "not signed in" do
      it "redirects to the sign in page" do
        delete :destroy, params: destroy_params

        expect(response).to have_http_status 302
        expect(response).to redirect_to RSpec.configuration.http_referer
      end
    end

    RSpec.configuration.user_roles.each do |role|
      __send__("controller_#{role}_sign_in".to_sym)

      context "signed in as: #{role}" do
        context "when successful" do
          it "redirects to the records index" do
            own_record
            patch :trash, params: destroy_params

            expect(response).to have_http_status 302
            expect(response).to redirect_to "#{records_path}?notice=#{record_to_s}+was+moved+to+the+trash%21"
          end
        end

        context "when failure" do
          it "redirects to the records index" do
            own_record
            mock_failure(:update_attributes)
            patch :trash, params: destroy_params

            expect(response).to have_http_status 302
            expect(response).to redirect_to "#{records_path}?alert=Cannot+send+#{record_to_s.downcase}+to+the+trash.+Please+try+again."
          end
        end
      end
    end
  end
end