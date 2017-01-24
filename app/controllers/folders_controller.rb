class FolderController < ApplicationController
  # POST /folders
  def create
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
    @folders = Folder.all
  end

  # GET /folders/new
  def new
    @folder = Folder.new
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

  def folder_params
    params.require(:folder).permit(:name, :path, :parent, :user)
  end
end
