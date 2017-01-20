class FlyersController < ApplicationController
  # POST /flyers
  def create
    @flyer = Flyer.new(flyer_params)

    if @flyer.save
      redirect_to generate_flyer_path(@flyer, format: :pdf)
    else

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

    build_pdf
    save_pdf
  end

  # GET /flyers
  def index

  end

  # GET /flyers/new
  def new

  end

  # GET /flyers/preview.pdf
  def preview
    force_format(:pdf)
    build_pdf
    render pdf: pdf_path
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

  def build_pdf
    @pdf = WickedPdf.new.pdf_from_string(@flyer.template.pdf_markup, pdf_options)
  end

  def save_pdf
    render pdf_options.merge({
      save_to_file: pdf_path,
      # save_only:    true
    })
  end

  def preview_pdf

  end

  def pdf_path
    @pdf_path ||= Rails.root.join("public", "pdfs", "#{@flyer.id}.pdf").to_s
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
