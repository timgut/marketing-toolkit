class Admin::UsersController < ApplicationController

  before_action :require_admin

  # POST /users
  def create
    @user = User.new(user_params)

    ## we could do the following to set an initial, hidden password -- which avoids some password confirmation issues later
    ## new_password = Devise.friendly_token(length = 50)
    ## @user.password = new_password
    ## @user.password_confirmation = new_password

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
    @approved = User.approved
    @unapproved = User.unapproved
    @rejected = User.rejected
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
  end

  # PATCH /users/1
  def update
    @user = User.find(params[:id])
    account_status = 'same'
    if !@user.approved? and params[:user][:approved] == '1'
      account_status = 'approved'
    elsif params[:user][:approved] == '0' and @user.approved?
      account_status = 'unapproved'
    elsif !@user.rejected? and params[:user][:rejected] == '1'
      account_status = 'rejected'
    end

    if @user.update_attributes!(user_params)
      unless account_status == 'same'
        @user.send_account_notification(account_status)
      end
      redirect_to edit_admin_user_path(@user), notice: "User updated!"
    else
      render :edit, notice: "There was a problem updating the user."
    end
  end

  def require_admin
    unless current_user && current_user.approved? && current_user.role == 'Administrator'
      flash[:notice] = "You are trying to reach a restricted area."
      redirect_to authenticated_root_path
    end        
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :approved, :rejected, :zip_code, :council, :local_number, :title, :cell_phone, :receive_alerts, :role)
  end
end