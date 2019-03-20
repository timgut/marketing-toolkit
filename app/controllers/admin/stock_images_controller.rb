class StockImagesController < ApplicationController
  before_action :set_stock_image, only: [:show, :edit, :update, :destroy]

  # GET /stock_images
  def index
    @stock_images = StockImage.all
  end

  # GET /stock_images/1
  def show
  end

  # GET /stock_images/new
  def new
    @stock_image = StockImage.new
  end

  # GET /stock_images/1/edit
  def edit
  end

  # POST /stock_images
  def create
    @stock_image = StockImage.new(stock_image_params)

    if @stock_image.save
      redirect_to @stock_image, notice: 'Stock image was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /stock_images/1
  def update
    if @stock_image.update(stock_image_params)
      redirect_to @stock_image, notice: 'Stock image was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /stock_images/1
  def destroy
    @stock_image.destroy
    redirect_to stock_images_url, notice: 'Stock image was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock_image
      @stock_image = StockImage.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def stock_image_params
      params.require(:stock_image).permit(:title, :image, :status)
    end
end
