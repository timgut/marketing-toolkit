class FoldersController < ApplicationController
  # POST /folders
  def create
    @parent = Folder.find(params[:folder][:parent_id])
    assign_path
    @folder = Folder.new(folder_params)

    if @folder.save
      redirect_to folder_path(@folder), notice: "Folder created!"
    else
      render :new
    end
  end

  # DELETE /folders
  def destroy
    @folder = Folder.find(params[:id])
  end

  # GET /folders/1/edit
  def edit
    @folder = Folder.find(params[:id])
  end

  # GET /folders
  def index
    @image_folders = User.current_user.image_folders
    @flyer_folders = User.current_user.flyer_folders
  end

  # GET /folders/new
  def new
    @folder = Folder.new(folder_params)
  end

  # GET /folders/1
  def show
    @folder = Folder.find(params[:id])
  end

  # PATCH /folders/1
  def update
    @folder = Folder.find(params[:id])

    if @folder.update_attributes(folder_params)
      redirect_to folder_path(@folder), notice: "Folder updated!"
    else
      render :edit, alert: "Cannot update folder!"
    end
  end

  private

  def assign_path
    params[:folder][:path] = "#{@parent.path}#{'/' unless @parent.is_root}#{params[:folder][:name]}"
  end

  def folder_params
    params.require(:folder).permit(:name, :path, :parent_id, :user_id, :type)
  end
end
