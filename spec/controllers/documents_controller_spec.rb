require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do
  let(:template)  { create(:template) }
  let!(:document) { create(:document) }
  let!(:data)     { create(:datum, document_id: document.id, key: "key", value: "value")}

  def create_params
    {
      document: {
        title:       "New Document",
        description: "This is my new document",
        status:      "publish",
        template_id: template.id,
        creator_id:  current_user.id
      },
      data: {
        key1: "value1",
        key2: "value2",
        key3: "value3"
      },
      select_data: {
        key1: "div1",
        key2: "div2",
        key3: "div3"
      }
    }
  end

  def destroy_params
    { id: document.id }
  end

  def new_params
    { template_id: template.id }
  end

  def update_params
    {
      id:          document.id,
      document:    {title: "New Title"},
      data:        [{key: "new_key", value: "new value"}],
      select_data: {new_key: "fieldId"}
    }
  end

  def mock_failure(method)
    allow_any_instance_of(Document).to receive(method).and_return(false)
  end

  def own_document
    document.update_attributes!(creator_id: current_user.id)
  end

  describe "Concerns" do
    it_behaves_like "Trashable" do
      let!(:record) { document }
    end
  end

  describe "POST create" do
    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        context "when successful" do
          it "creates new records and redirects to the documents index" do
            expect { post :create, params: create_params }.to change(Document, :count).by(1)
            expect { post :create, params: create_params }.to change(DocumentUser, :count).by(1)
            expect { post :create, params: create_params }.to change(Datum, :count).by(3)
        
            post :create, params: create_params

            expect(response).to have_http_status(302)
            expect(response).to redirect_to documents_path
          end
        end
        
        context "when failure" do
          it "creates new records and redirects to the documents index" do
            mock_failure(:save)

            expect { post :create, params: create_params }.to change(Document, :count).by(0)
            expect { post :create, params: create_params }.to change(DocumentUser, :count).by(0)
            expect { post :create, params: create_params }.to change(Datum, :count).by(0)
        
            post :create, params: create_params

            expect(response).to have_http_status(302)
            expect(response).to redirect_to RSpec.configuration.http_referer
          end
        end

      end
    end
  end

  describe "GET duplicate" do
    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        context "when successful" do
          it "creates new records and redirects to the new document" do
            document.update_attributes!(creator_id: current_user.id)
            
            expect { get :duplicate, params: destroy_params }.to change(Document, :count).by(1)
            expect { get :duplicate, params: destroy_params }.to change(DocumentUser, :count).by(1)
            expect { get :duplicate, params: destroy_params }.to change(Datum, :count).by(1)

            get :duplicate, params: destroy_params

            expect(response).to have_http_status(302)
            expect(response).to redirect_to edit_document_path(Document.last)
          end
        end
        
        context "when failure" do
          it "creates new records and redirects to the documents index" do
            own_document
            mock_failure(:save!)

            expect { get :duplicate, params: destroy_params }.to change(Document, :count).by(0)
            expect { get :duplicate, params: destroy_params }.to change(DocumentUser, :count).by(0)
            expect { get :duplicate, params: destroy_params }.to change(Datum, :count).by(0)
        
            get :duplicate, params: destroy_params

            expect(response).to have_http_status(302)
            expect(response).to redirect_to edit_document_path(document)
          end
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

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "renders the edit template" do
          own_document
          get :edit, params: destroy_params

          expect(response).to have_http_status 200
          expect(response).to render_template "edit"
        end
      end
    end
  end

  describe "GET #download" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :download, params: destroy_params
        expect(response).to have_http_status 302
        expect(response.body).to eq RSpec.configuration.redirect_html
      end
    end

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "downloads the PDF" do
          own_document
          get :edit, params: destroy_params

          expect(response).to have_http_status 200
        end
      end
    end
  end

  [:recent, :shared, :index].each do |action|
    describe "GET ##{action}" do
      context "not signed in" do
        it "redirects to the sign in page" do
          get action
          expect(response).to have_http_status 302
          expect(response.body).to eq RSpec.configuration.redirect_html
        end
      end

      RSpec.configuration.user_roles.each do |role|
        context "signed in as: #{role}" do
          __send__("controller_#{role}_sign_in".to_sym)

          it "renders the index template" do
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
        get :new, params: new_params

        expect(response).to have_http_status 302
        expect(response.body).to eq RSpec.configuration.redirect_html
      end
    end

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "renders the new template" do
          get :new, params: new_params

          expect(response).to have_http_status 200
          expect(response).to render_template "new"
        end
      end
    end
  end

  describe "GET #preview" do
    context "not signed in" do
      it "redirects to the sign in page" do
        get :preview, params: destroy_params
        expect(response).to have_http_status 302
        expect(response.body).to eq RSpec.configuration.redirect_html
      end
    end

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        it "renders the build template" do
          own_document
          get :preview, params: destroy_params

          expect(response).to have_http_status 200
          expect(response).to render_template "documents/build.pdf.erb"
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

    RSpec.configuration.user_roles.each do |role|
      context "signed in as: #{role}" do
        __send__("controller_#{role}_sign_in".to_sym)

        context "when successful" do
          it "redirects to the document edit page" do
            own_document
            patch :update, params: update_params
            
            expect(response).to have_http_status 302
            expect(response.body).to redirect_to edit_document_path(document)
          end
        end

        context "when failure" do
          it "renders the edit template" do
            own_document
            mock_failure(:update_attributes)
            patch :update, params: update_params

            expect(response).to have_http_status 302
            expect(response.body).to redirect_to RSpec.configuration.http_referer
          end
        end
      end
    end
  end
end
