class ImagesController < ApplicationController
  include Trashable

  before_action :assign_sidebar_vars, only: [:index, :recent, :shared, :trashed]

  # GET /images/choose
  def choose
    @images = current_user.images.publish.reverse
    @stock_images = StockImage.all
    render layout: false
  end

  # POST /images
  def create
    @image = Image.new(creator_id: current_user.id)
    authorize @image

    if @image.save
      ImageUser.create!(image: @image, user: current_user)    
      render json: @image.to_json
    else
      render json: @image.errors.to_json
    end
  end

  # GET /images/1/contextual_crop
  def contextual_crop
    load_image
    set_cropping_data

    render layout: false
  end

  # GET /images/1/papercrop
  def papercrop
    load_image
    set_cropping_data

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
    @image.paperclip_resize = true

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

  # POST /images/1/upload_photo
  def upload_photo
    @image = Image.find(params[:id])
    persist_tmpfile!
    UploadPhotoJob.perform_async(image: @image, filepath: @tmpfile_path, filename: params[:photo].original_filename)
    head :no_content
  end

  # GET /images/1/upload_photo_status
  def upload_photo_status
    @image = Image.find(params[:id])
    render json: @image.as_json.merge({uploaded: @image.uploaded_photo?})
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

    @image.reset_crop_data
    @image.reset_commands    
  end

  # Set the strategy; Set data for the processors; Call the processors.
  def set_cropping_data
    @image.strategy = params[:image].delete(:strategy)&.to_sym
    __send__("set_#{@image.strategy}_resize_data".to_sym)
    @image.image.reprocess!
  end

  # Set the target height/width for Papercrop.
  def set_papercrop_resize_data
    params[:image].delete(:template_id)
    @image.resize_height = params[:image].delete(:resize_height)
    @image.resize_width  = params[:image].delete(:resize_width)
  end

  # Set the context image and the drag data for contextual crop.
  def set_contextual_crop_resize_data
    @template      = Template.find(params[:image].delete(:template_id))
    @image.context = @template
    @image.pos_x   = params[:image].delete(:pos_x)
    @image.pos_y   = params[:image].delete(:pos_y)
  end

  def persist_tmpfile!
    @tmpfile_path = Rails.root.join("tmp").join("#{current_user.id}-#{params[:photo].original_filename}")
    File.open(@tmpfile_path, 'wb') {|file| file << File.read(params[:photo].tempfile.path)}
  end
end
