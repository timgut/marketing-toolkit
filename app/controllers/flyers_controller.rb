class FlyersController < ApplicationController
  # POST /flyers
  def create
    @flyer = Flyer.new(flyer_params)

    if @flyer.save
      redirect_to generate_flyer_path(@flyer)
    else

    end
  end

  # DELETE /flyers
  def destroy

  end

  # GET /flyers/1/edit
  def edit

  end

  # GET /flyer/1/generate
  def generate
    build_pdf
    save
  end

  # GET /flyers
  def index

  end

  # GET /flyers/new
  def new

  end

  # GET /flyers/preview
  def preview
    build_pdf
  end

  # GET /flyers/1
  def show

  end

  # PATCH /flyers/1
  def update

  end

  private

  def flyer_params
    params.require(:flyer).permit!
  end

  def build_pdf
    @pdf = WickedPdf.new.pdf_from_string(@flyer.template.markup, pdf_options)
  end

  def save
    File.open(Rails.root.join("public", "pdfs", "#{@flyer.id}.pdf"), 'wb') do |file|
      file << @pdf
    end
  end

  def pdf_options
    {
      pdf:           @flyer.title,
      disposition:   :inline,
      orientation:   "Portrait",
      grayscale:     false,
      lowquality:    false,
      image_quality: 94,
      show_as_html:  params[:debug],
      page_height:   @flyer.template.height,
      page_width:    @flyer.template.width,
      margin:  {
        top:    0,
        bottom: 0,
        left:   0,
        right:  0
      }
    }.merge(params[:pdf_options])
  end
end
