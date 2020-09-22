class ImagesController < ApplicationController
  include Trashable

  before_action :assign_sidebar_vars, only: [:index, :recent, :shared, :trashed]

  # GET /images/choose?template_id=1
  def choose
    @my_photos = current_user.images.select(:id, :original_image_url, :cropped_image_url).publish.reverse
    @stock_photos = StockImage.select(:id, :title, :label, :image_url).publish
    @template = Template.find(params[:template_id])
    render layout: false
  end

  # POST /images
  def create
    @image = Image.new(creator_id: current_user.id)
    authorize @image

    if @image.save
      ImageUser.create!(image: @image, user: current_user)   
      @image.upload_to_s3!(params[:photo])
      render json: @image.to_json
    else
      render json: @image.errors.to_json
    end
  end

  # GET /images/1/edit
  def edit
    load_image
  end

  # GET /images
  def index
    @images = current_user.images.not_trashed.reverse
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

  # GET /images/shared
  def shared
    @images = @shared
    render :index
  end

  # GET /images/1
  def show
    load_image
  end

  # PATCH /images/1
  def update
    load_image

    respond_to do |format|
      format.html do
        if @image.update_attributes(image_params)
          redirect_to images_path, notice: "Image saved!"
        else
          render :edit, alert: "Cannot update image!"
        end
      end

      format.json do
        if @image.update_attributes(image_params)
          render json: @image.to_json
        else
          render json: @image.errors.to_json
        end
      end
    end
  end

  # GET /images/1/upload_photo_status
  def upload_photo_status
    @image = Image.find(params[:id])
    render json: @image.as_json.merge({uploaded: @image.uploaded_photo?})
  end

  private

  def assign_sidebar_vars
    @all          = current_user.images.all.not_trashed
    @recent       = current_user.images.recent(current_user).not_trashed
    @shared       = current_user.images.shared_with_me(current_user).not_trashed
    @trashed      = current_user.images.trash
    @documents    = current_user.documents.not_trashed
    @stock_images = StockImage.all
  end

  def image_params
    params.require(:image).permit!
  end

  def load_image
    if params[:stock_photo]
      @stock_image = StockImage.find(params[:id])
      @image = Image.create(
        image_file_name: "#{@stock_image.image_file_name}-#{DateTime.now.to_i}", 
        creator: current_user, 
        image: @stock_image.image
      )
      ImageUser.create(image: @image, user: current_user)
    else
      @image = Image.find(params[:id])
      authorize @image
    end
  end
end
