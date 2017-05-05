class ImagesController < ApplicationController
  include Trashable

  before_action :assign_sidebar_vars, only: [:index, :recent, :shared, :trashed]

  # POST /images
  def create
    @image = Image.new(image_params)

    respond_to do |format|
      format.html do
        if @image.save
          ImageUser.create!(image: @image, user: User.current_user)    
          redirect_to image_path(@image), notice: "Image created!"
        else
          render :new, alert: "Cannot create image."
        end
      end

      format.json do
        if @image.save
          ImageUser.create!(image: @image, user: User.current_user)    
          render json: {url: @image.image.url}
        else
          render plain: @image.errors.full_messages.to_sentence, status: 403
        end
      end
    end
  end

  # GET /images/choose
  def choose
    @images = current_user.images
    render layout: false
  end

  # GET /images/1/edit
  def edit
    @image = Image.find(params[:id])
  end

  # GET /images
  def index
    if current_user
      @images = current_user.images.not_trashed
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

    respond_to do |format|
      format.html do
        if @image.update_attributes(image_params)
          redirect_to image_path(@image), notice: "Image updated!"
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

  def assign_sidebar_vars
    @all       = current_user.images.all.not_trashed
    @recent    = current_user.images.recent.not_trashed
    @shared    = current_user.images.shared_with_me.not_trashed
    @trashed   = current_user.images.trash
    @documents = current_user.document.not_trashed
  end

  def image_params
    params.require(:image).permit(:image, :creator_id)
  end
end
