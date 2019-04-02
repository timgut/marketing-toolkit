class Admin::StockImagesController < AdminController
  before_action :set_stock_image, only: [:show, :edit, :update, :destroy]

  # GET /admin/stock_images
  def index
    @stock_images = StockImage.all
  end

  # GET /admin/stock_images/1
  def show
  end

  # GET /admin/stock_images/new
  def new
    @stock_image = StockImage.new
  end

  # GET /admin/stock_images/1/edit
  def edit
    @stock_image = StockImage.find(params[:id])
  end

  # POST /admin/stock_images
  def create
    @stock_image = StockImage.new(stock_image_params)

    if @stock_image.save
      redirect_to admin_stock_image_path(@stock_image), notice: 'Stock image created!'
    else
      render :new, alert: "Cannot create stock image."
    end
  end

  # PATCH/PUT /admin/stock_images/1
  def update
    if @stock_image.update_attributes(stock_image_params)
      redirect_to admin_stock_image_path(@stock_image), notice: 'Stock image saved!'
    else
      render :edit, alert: "Cannot update image!"
    end
  end

  # DELETE /admin/stock_images/1
  def destroy
    @stock_image.destroy
    redirect_to admin_stock_images_path, notice: 'Stock image was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock_image
      @stock_image = StockImage.find(params[:id])
    end
    
    def load_stock_image
      @stock_image = StockImage.find(params[:id])
      authorize @stock_image
    end

    # Only allow a trusted parameter "white list" through.
    def stock_image_params
      params.require(:stock_image).permit(:title, :image, :status, :label)
    end
end
