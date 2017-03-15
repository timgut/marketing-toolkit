class ImagesController < ApplicationController
  before_action :assign_records, only: [:index, :recent, :shared]
  before_action :authenticate_user!

  # POST /images
  def create
    @image = Image.new(image_params)

    respond_to do |format|
      format.html do
        if @image.save
          ImageUser.create!(image: @image, user: User.current_user)    
          redirect_to resize_image_path(@image), notice: "Image created! You may now crop the image."
        else
          render :new, alert: "Cannot create image."
        end
      end

      format.json do
        if @image.save
          ImageUser.create!(image: @image, user: User.current_user)    
          render json: {id: @image.id, url: @image.image.url}
        else
          render plain: @image.errors.full_messages.to_sentence, status: 403
        end
      end
    end
  end

  # GET /images/choose
  def choose
    @images = User.current_user.images
    render layout: false
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
    if current_user
      @images = current_user.images
    else
      @images = @all
    end
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

  # GET /images/1/crop
  def crop
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

    respond_to do |format|
      format.html do
        if @image.update_attributes(image_params)
          redirect_to images_path, notice: "Image updated!"
        else
          render :edit, alert: "Cannot update image!"
        end
      end

      format.json do
        @image.update_attributes(image_params)
        head :no_content
      end
    end
  end

  private

  def assign_records
    @all    = Image.all
    @recent = Image.recent
    @shared = Image.shared_with_me
  end

  def image_params
    params.require(:image).permit(
      :image, :creator_id, :image_original_w, :image_original_h, :image_box_w, 
      :image_aspect, :image_crop_x, :image_crop_y, :image_crop_w, :image_crop_h
    )
  end
end
