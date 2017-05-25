class ImagesController < ApplicationController
  include Trashable

  before_action :assign_sidebar_vars, only: [:index, :recent, :shared, :trashed]

  # GET /images/choose
  def choose
    @images = current_user.images.publish
    render layout: false
  end

  # POST /images
  def create
    @image = Image.new(image_params)

    respond_to do |format|
      format.html do
        if @image.save
          ImageUser.create!(image: @image, user: current_user)    
          redirect_to images_path(@image), notice: "Image created!"
        else
          render :new, alert: "Cannot create image."
        end
      end

      format.json do
        if @image.save
          ImageUser.create!(image: @image, user: current_user)    
          render json: {id: @image.id, url: @image.image.url, cropped_url: @image.image.url(:cropped), file_name: @image.image_file_name}
        else
          render plain: @image.errors.full_messages.to_sentence, status: 403
        end
      end
    end
  end

  # GET /images/1/crop
  def crop
    @image    = Image.find(params[:id])
    @template = Template.find(params[:template_id])
    set_resize_data
    @image.image.reprocess!

    render :crop_modal, layout: false
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
    set_cropping_data

    respond_to do |format|
      format.html do
        if @image.update_attributes(image_params)
          redirect_to images_path, notice: "Image saved!"
        else
          render :edit, alert: "Cannot update image!"
        end
      end

      format.json do
        @image.update_attributes(image_params)
        @image.set_crop_data!
        render json: {id: @image.id, url: @image.image.url, cropped_url: @image.image.url(:cropped), file_name: @image.image_file_name}
      end
    end
  end

  private

  def assign_sidebar_vars
    @all       = current_user.images.all.not_trashed
    @recent    = current_user.images.recent(current_user).not_trashed
    @shared    = current_user.images.shared_with_me(current_user).not_trashed
    @trashed   = current_user.images.trash
    @documents = current_user.documents.not_trashed
  end

  def image_params
    params.require(:image).permit(
      :image, :creator_id, :pos_x, :pos_y, :template_id
    )
  end

  def set_resize_data
    @image.resize  = true
    @image.context = @template
  end

  def set_cropping_data
    @image.context = Template.find(params[:image].delete(:template_id))
    @image.pos_x = params[:image].delete(:pos_x)
    @image.pos_y = params[:image].delete(:pos_y)

    # Paperclip processors run in order starting with the original image, so it needs to be resized again before cropping.
    if @image.cropping?
      @image.resize = true
    end
  end
end
