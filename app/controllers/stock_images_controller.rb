class StockImagesController < ApplicationController
  before_action :assign_sidebar_vars, only: [:index, :show]

  # GET /stock_images
  def index
    @stock_images = StockImage.all
  end
  # GET /images/1
  def show
    @stock_image = StockImage.find(params[:id])
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
