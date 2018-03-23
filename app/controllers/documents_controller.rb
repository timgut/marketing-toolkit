class DocumentsController < ApplicationController
  include Trashable

  protect_from_forgery except: :create

  before_action :assign_sidebar_vars, only: [:index, :recent, :shared, :trashed]

  skip_before_action :authenticate_user!, if: ->{ is_phantomjs_request? }
  
  # POST /documents
  def create
    @document = Document.new(document_params)

    if @document.save
      DocumentUser.create!(document_id: @document.id, user_id: current_user.id)
      create_data
      DocumentGeneratorJob.perform_async(@document, current_user)

      redirect_to documents_path(generating: @document.id), notice: "Document created!"
    else
      redirect_back fallback_location: documents_path
    end
  end

  # GET /documents/1/duplicate
  def duplicate
    @original_document = Document.find(params[:id])
    authorize @original_document

    if @document = @original_document.duplicate!(current_user)
      redirect_to edit_document_path(@document), notice: "#{@original_document.title} was duplicated and saved. You are editing the new document."
    else
      redirect_to edit_document_path(@original_document), notice: "Cannot duplicate this document. Please try again."
    end
  end

  # GET /documents/1/edit
  def edit
    load_document
    assign_records
  end

  # GET /documents/1/download
  def download
    load_document
    # @document.generate_share_graphic(current_user.id)
    DocumentGeneratorJob.perform_async(@document, current_user)
    head :no_content
  end

  # GET /documents
  def index
    if params[:category_id]
      @filtered_documents = @documents.select{ |document| 
        document.template.category_id == params[:category_id].to_i
      }.reverse
    else
      @filtered_documents = @documents.reverse
    end

    @filtered_documents = paginate(@filtered_documents)
  end

  # GET /documents/1/job_status
  def job_status
    load_document

    respond_to do |format|
      format.json do
        if @document.generated?
          case @document.template.format
          when "pdf"
            render json: {status: :complete, thumbnail: @document.thumbnail.url, pdf: @document.pdf.url}
          when "png"
            render json: {status: :complete, thumbnail: @document.thumbnail.url, pdf: @document.share_graphic.url}
          end
        else
          render json: {status: :incomplete}
        end
      end
    end
  end

  # GET /documents/new
  def new
    @template = Template.find(params[:template_id])
    @document = Document.new(template_id: @template.id, title: @template.title, description: @template.description)
    authorize_campaign!(@document)
    assign_records
  end

  # GET /documents/1/preview
  def preview
    load_document
    @document.debug_pdf = true
    # render @document.pdf_options

    av = ActionView::Base.new
    av.view_paths = ActionController::Base.view_paths
    html = av.render(template: "documents/build.pdf.erb", locals: {document: @document})
    render html: html
  end

  # GET /documents/recent
  def recent
    @filtered_documents = Document.includes(:template).recent(current_user).not_trashed.reverse
    @filtered_documents = paginate(@filtered_documents)
    render :index
  end

  # GET /documents/1/share
  def share
    @document = Document.includes(:template).find(params[:id])
  end

  # GET /documents/shared
  def shared
    @filtered_documents = Document.includes(:template).shared_with_me(current_user)
    @filtered_documents = paginate(@filtered_documents)
    @shared = true
    render :index
  end

  # PATCH /documents/1
  def update
    load_document
    @document.pdf = nil
    @document.thumbnail = nil

    if @document.update_attributes(document_params)
      ActiveRecord::Base.transaction do
        delete_data
        create_data
      end

      DocumentGeneratorJob.perform_async(@document, current_user)

      redirect_to edit_document_path(@document, generating: true), notice: "Your changes have been saved."
    else
      redirect_back fallback_location: documents_path, error: alert_message
    end
  end

  protected

  def assign_sidebar_vars
    if current_user
      @documents = current_user.documents.includes(:template, :creator).not_trashed
      @images = current_user.images.not_trashed
    else
      @documents = Document.includes(:template, :creator).not_trashed
      @images = Image.not_trashed
    end

    @recent = @documents.recent(current_user)

    @campaigns = current_user.campaigns.publish
    @trashed   = current_user.documents.trash


    @sidebar_vars = @categories.inject([]) do |sidebar_vars, category|
      sidebar_vars << {
        category_id: category.id,
        title:       category.title,
        items:       @documents.select{|document| document.template.category_id == category.id}
      }
    end
  end

  private

  def assign_records
    @template  = @document.template
    @campaigns = @template.campaigns
    @custom_branding = current_user.custom_branding?
  end

  def create_data
    select_data = params.delete(:select_data)

    params.delete(:data).each do |key, value|
      Datum.create!(document_id: @document.id, key: key, value: value, field_id: select_data[key])
    end
  end

  def delete_data
    @document.data.destroy_all
  end

  def document_params
    params.require(:document).permit(:title, :description, :status, :crop_marks, :template_id, :creator_id)
  end

  def load_document
    @document = Document.find(params[:id])

    if is_phantomjs_request?
      @document.phantomjs_user = User.find(request.headers["X-TOOLKIT-USERID"])
      authorize @document, :phantomjs_user_can_access_document?
    else
      authorize_campaign!(@document)
      authorize @document
    end
  end

  def is_phantomjs_request?
    request.params["action"] == "preview" &&
    request.headers["X-TOOLKIT-USERID"].present? && 
    request.env["HTTP_USER_AGENT"]["PhantomJS"].present?
  end
end
