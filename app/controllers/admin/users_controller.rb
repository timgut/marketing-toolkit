class Admin::UsersController < ApplicationController
  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to user_path(@user), notice: "User created!"
    else
      render :new
    end
  end

  # DELETE /users
  def destroy
    @user = User.find(params[:id])
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @body_class = 'toolkit USER'
    @header_navigation = true
  end

  # GET /users
  def index
    @users = User.all
  end

  def applications
    if current_user && current_user.admin?
      @users = User.unapproved
      @header_navigation = true
      @body_class = "toolkit application-queue"
      render "admin/users/applications"
    else
      flash[:notice] = "You are trying to reach a restricted area."
      redirect_to authenticated_root_path 
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1
  def show
    @user = User.includes(:templates).find(params[:id])
  end

  # PATCH /users/1
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to user_path(@user), notice: "User updated!"
    else
      render :edit, alert: "Cannot update user!"
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :zip_code, :council, :local_number, :title, :cell_phone, :receive_alerts, :role)
  end
end