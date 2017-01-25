class FlyersController < ApplicationController
  protect_from_forgery except: :create

  # POST /flyers
  def create
    @flyer = Flyer.new(flyer_params)

    if @flyer.save
      FlyerUser.create!(flyer_id: @flyer.id, user_id: User.current_user.id, creator_id: User.current_user.id)
      create_data
      redirect_to generate_flyer_path(@flyer, format: :pdf)
    else
      redirect_back fallback_location: root_path
    end
  end

  # DELETE /flyers
  def destroy
    @flyer = Flyer.find(params[:id])
  end

  # GET /flyers/1/edit
  def edit
    @flyer = Flyer.find(params[:id])
  end

  # GET /flyers/1/generate.pdf
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
    @flyers = Flyer.all
  end

  # GET /flyers/new
  def new
    @flyer = Flyer.new

    if template_selected?
      @template = Template.find(params[:flyer][:template])
      render :new2
    else
      @templates = Template.all
      render :new
    end
  end

  # GET /flyers/preview.pdf
  def preview
    force_format(:pdf)
    render pdf_options
  end

  # GET /flyers/1
  def show
    @flyer = Flyer.find(params[:id])
  end

  # PATCH /flyers/1
  def update
    @flyer = Flyer.find(params[:id])
  end

  private

  def flyer_params
    params.require(:flyer).permit!
  end

  def force_format(format)
    params[:format] = format
  end

  def template_selected?
    begin
      params.dig(:flyer).dig(:template)
    rescue
      false
    end
  end

  def create_data
    params.delete(:data).each do |key, value|
      Datum.create!(flyer_id: @flyer.id, key: key, value: value)
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
end
