class StockImagesController < ApplicationController
  before_action :assign_sidebar_vars, only: [:index, :show]

  # GET /stock_images
  def index
    @stock_images = StockImage.all
  end

  # GET /stock_images/1
  def show
    @stock_image = StockImage.find(params[:id])
  end

  # POST /stock_images/1/duplicate
  def duplicate
    @stock_image = StockImage.find(params[:id])
    
    if image = @stock_image.upload_to_s3!(user_id: params[:user_id])
      render json: image.to_json
    else
      render json: {error: "Cannot crop stock image"}.to_json
    end
  end

  private

  def assign_sidebar_vars
    @all       = current_user.images.all.not_trashed
    @recent    = current_user.images.recent(current_user).not_trashed
    @shared    = current_user.images.shared_with_me(current_user).not_trashed
    @trashed   = current_user.images.trash
    @documents = current_user.documents.not_trashed
    @stock_images = StockImage.all
  end
end
