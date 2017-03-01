class FlyersController < ApplicationController
  protect_from_forgery except: :create

  before_action :assign_records, except: [:index]

  before_action :authenticate_user!

  # POST /campaigns/1/templates/1/flyers
  def create
    @flyer = Flyer.new(flyer_params)

    if @flyer.save
      FlyerUser.create!(flyer_id: @flyer.id, user_id: User.current_user.id, creator_id: User.current_user.id)
      create_data

      # Eventually we'll redirect to another location, and send this to a background job.
      if params[:generate] == "true"
        redirect_to generate_campaign_template_flyer_path(@campaign, @template, @flyer, format: :pdf, debug: true)
      else
        redirect_to flyers_path, notice: "Flyer created!"
      end
    else
      redirect_back fallback_location: root_path
    end
  end

  # DELETE /campaigns/1/templates/1/flyers
  def destroy
    @flyer = Flyer.find(params[:id])
  end

  # GET /campaigns/1/templates/1/flyers/1/edit
  def edit
    @flyer = Flyer.find(params[:id])
    @images = Image.all
  end

  # GET /campaigns/1/templates/1/flyers/1/generate.pdf
  def generate
    force_format(:pdf)
    
    @flyer = Flyer.find(params[:id])

    if params[:debug]
      render pdf_options
    else
      pdf = render pdf_options.merge(save_to_file: @flyer.local_pdf_path, save_only: true)

      @flyer.pdf = File.open(@flyer.local_pdf_path)
      @flyer.save
      File.delete(@flyer.local_pdf_path)

      redirect_to @flyer.pdf.url
    end
  end

  # GET /flyers
  def index
    @flyers = Flyer.includes(:template, template: [:campaign]).all
  end

  # GET /campaigns/1/templates/1/flyers/new
  def new
    @flyer = Flyer.new(template_id: @template.id, title: @template.title, description: @template.description)
    @images = Image.all
  end

  # GET /campaigns/1/templates/1/flyers/preview.pdf
  def preview
    force_format(:pdf)
    render pdf_options
  end

  # GET /campaigns/1/templates/1/flyers/1
  def show
    @flyer = Flyer.find(params[:id])
  end

  # PATCH /campaigns/1/templates/1/flyers/1
  def update
    @flyer = Flyer.find(params[:id])

    if @flyer.save
      ActiveRecord::Base.transaction do
        delete_data
        create_data
      end

      # Eventually we'll redirect to another location, and send this to a background job.
      if params[:generate] == "true"
        redirect_to generate_campaign_template_flyer_path(@campaign, @template, @flyer, format: :pdf, debug: true)
      else
        redirect_to flyers_path(@campaign, @template), notice: "Flyer created!"
      end
    else
      redirect_back fallback_location: root_path
    end
  end

  private

  def flyer_params
    params.require(:flyer).permit(:title, :description, :status, :template_id)
  end

  def force_format(format)
    params[:format] = format
  end

  def delete_data
    @flyer.data.destroy_all
  end

  def create_data
    select_data = params.delete(:select_data)

    params.delete(:data).each do |key, value|
      Datum.create!(flyer_id: @flyer.id, key: key, value: value, field_id: select_data[key])
    end
  end

  def pdf_options
    {
      pdf:           @flyer.title,
      template:      "flyers/build.pdf.erb",
      disposition:   :inline,
      orientation:   "Portrait",
      grayscale:     false,
      lowquality:    false,
      image_quality: 94,
      show_as_html:  params[:debug],
      page_height:   "#{@flyer.template.height}in",
      page_width:    "#{@flyer.template.width}in",
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
    @campaign = Campaign.find(params[:campaign_id])
    @template = Template.find(params[:template_id])
  end
end
