class ImagesController < ApplicationController
  include Trashable

  before_action :assign_sidebar_vars, only: [:index, :recent, :shared, :trashed]

  # GET /images/choose
  def choose
    @images = current_user.images.publish.reverse
    render layout: false
  end

  # POST /images
  def create
    @image = Image.new(image_params)
    authorize @image

    respond_to do |format|
      format.html do
        if @image.save
          ImageUser.create(image: @image, user: current_user)    
          redirect_to image_path(@image), notice: "Image created!"
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

  # GET /images/1/contextual_crop
  def contextual_crop
    load_image
    set_cropping_data
    @image.image.reprocess!

    render layout: false
  end

  # GET /images/1/papercrop
  def papercrop
    load_image
    set_papercrop_resize_data
    render layout: false
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
        if @image.update_attributes(image_params)
          @image.set_crop_data!
          render json: {id: @image.id, url: @image.image.url, cropped_url: @image.image.url(:cropped), file_name: @image.image_file_name}
        else
          render plain: @image.errors.full_messages.to_sentence, status: 403
        end
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
      :image, :creator_id, :pos_x, :pos_y, :template_id,
      :image_original_w, :image_original_h, :image_box_w, :image_aspect, :image_crop_x, :image_crop_y, :image_crop_w, :image_crop_h,
      :resize_height, :resize_width
    )
  end

  def load_image
    @image = Image.find(params[:id])
    authorize @image
  end

  def set_cropping_data
    @image.strategy = params[:image].delete(:strategy)&.to_sym

    case @image.strategy
    when :papercrop
      params[:image].delete(:template_id)
      set_papercrop_resize_data
    when :contextual_crop
      @template      = Template.find(params[:image].delete(:template_id))
      @image.context = @template
      @image.pos_x   = params[:image].delete(:pos_x)
      @image.pos_y   = params[:image].delete(:pos_y)
    end
  end

  def set_papercrop_resize_data
    @image.resize_height = params[:image].delete(:resize_height)
    @image.resize_width  = params[:image].delete(:resize_width)
  end
end
