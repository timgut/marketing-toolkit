class ImagesController < ApplicationController
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
    @images = Image.all
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/resize
  def resize
    @image = Image.find(params[:id])
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

  def image_params
    params.require(:image).permit(:image, :folder_id)
  end
end
