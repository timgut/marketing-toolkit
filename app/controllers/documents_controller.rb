class DocumentsController < ApplicationController
  protect_from_forgery except: :create

  before_action :authenticate_user!
  before_action :assign_sidebar_vars, only: [:index, :recent, :shared, :trash]

  # POST /documents
  def create
    @document = Document.new(document_params)

    if @document.save
      DocumentUser.create!(document_id: @document.id, user_id: User.current_user.id, creator_id: User.current_user.id)
      create_data

      # Eventually we'll redirect to another location, and send this to a background job.
      if params[:generate] == "true"
        redirect_to generate_document_path(@document, format: :pdf)
      else
        redirect_to documents_path, notice: "Document created!"
      end
    else
      redirect_back fallback_location: root_path
    end
  end

  # DELETE /documents/1
  def destroy
    @document = Document.find(params[:id])
  end

  # GET /documents/1/duplicate
  def duplicate
    @document = Document.find(params[:id])
    @images = Image.all
    assign_records
  end

  # GET /documents/1/edit
  def edit
    @document = Document.find(params[:id])
    @images = Image.all
    assign_records
  end

  # GET /documents/1/generate.pdf
  def generate
    force_format(:pdf)
    
    @document = Document.find(params[:id])

    if params[:debug]
      render pdf_options
    else
      pdf = render pdf_options.merge(save_to_file: @document.local_pdf_path, save_only: true)

      @document.pdf = File.open(@document.local_pdf_path)
      @document.save
      File.delete(@document.local_pdf_path)

      redirect_to @document.pdf.url
    end
  end

  # GET /documents
  def index
    @filtered_documents = @documents
  end

  # GET /documents/new
  def new
    @template = Template.find(params[:template_id])
    @document = Document.new(template_id: @template.id, title: @template.title, description: @template.description)
    @images = Image.all
    assign_records
  end

  # GET /documents/preview.pdf
  def preview
    force_format(:pdf)
    render pdf_options
  end

  # GET /documents/recent
  def recent
    @filtered_documents = Document.includes(:template).recent
    render :index
  end

  # GET /documents/shared
  def shared
    @filtered_documents = Document.includes(:template).shared_with_me
    render :index
  end

  # GET /documents/1
  def show
    @document = Document.includes(:template).find(params[:id])
    assign_records
  end

  # GET /documents/trash
  def trash
    @filtered_documents = Document.includes(:template).trash
    render :index
  end

  # PATCH /documents/1
  def update
    @document = Document.find(params[:id])

    if @document.save
      ActiveRecord::Base.transaction do
        delete_data
        create_data
      end

      # Eventually we'll redirect to another location, and send this to a background job.
      if params[:generate] == "true"
        redirect_to generate_document_path(@document, format: :pdf)
      else
        redirect_to documents_path, notice: "Document created!"
      end
    else
      redirect_back fallback_location: root_path
    end
  end

  private

  def document_params
    params.require(:document).permit(:title, :description, :status, :template_id)
  end

  def force_format(format)
    params[:format] = format
  end

  def delete_data
    @document.data.destroy_all
  end

  def create_data
    select_data = params.delete(:select_data)

    params.delete(:data).each do |key, value|
      Datum.create!(document_id: @document.id, key: key, value: value, field_id: select_data[key])
    end
  end

  def pdf_options
    {
      pdf:           @document.title,
      template:      "documents/build.pdf.erb",
      disposition:   :inline,
      orientation:   "Portrait",
      grayscale:     false,
      lowquality:    false,
      image_quality: 94,
      show_as_html:  params[:debug],
      page_height:   "#{@document.template.height}in",
      page_width:    "#{@document.template.width}in",
      zoom: 1,
      margin:  {
        top:    0,
        bottom: 0,
        left:   0,
        right:  0
      }
    }
  end

  def assign_records
    @template = @document.template
    @campaign = @template.campaign
  end
end
