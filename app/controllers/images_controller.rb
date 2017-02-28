class ImagesController < ApplicationController
  before_action :assign_records, only: [:index, :recent, :shared]
  before_action :authenticate_user!

  # POST /images
  def create
    @image = Image.new(image_params)

    if @image.save
      ImageUser.create!(image: @image, user: User.current_user, creator: User.current_user)
      redirect_to image_path(@image), notice: "Image created!"
    else
      render :new
    end
  end

  # DELETE /images
  def destroy
    @image = Image.find(params[:id])

    if @image.destroy
      redirect_to images_path, notice: "Image deleted!"
    else
      redirect_back fallback_location: root_path, alert: "Cannot delete image. Please try again."
    end
  end

  # GET /images/1/edit
  def edit
    @image = Image.find(params[:id])
  end

  # GET /images
  def index
    @images = @all
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/recent
  def recent
    @images = @recent
    render :index
  end

  # GET /images/1/resize
  def resize
    @image = Image.find(params[:id])
  end

  # GET /images/shared
  def shared
    @images = @shared
    render :index
  end

  # GET /images/1
  def show
    @image = Image.find(params[:id])
  end

  # PATCH /images/1
  def update
    @image = Image.find(params[:id])

    if @image.update_attributes(image_params)
      redirect_to image_path(@image), notice: "Image updated!"
    else
      render :edit, alert: "Cannot update image!"
    end
  end

  private

  def assign_records
    @all    = Image.all
    @recent = Image.recent
    @shared = Image.shared_with_me
  end

  def image_params
    params.require(:image).permit(:image)
  end
end
