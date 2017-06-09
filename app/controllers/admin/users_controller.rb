class Admin::UsersController < AdminController
  # POST /users
  def create
    @user = User.new(user_params)
    authorize @user
    ## we could do the following to set an initial, hidden password -- which avoids some password confirmation issues later
    ## new_password = Devise.friendly_token(length = 50)
    ## @user.password = new_password
    ## @user.password_confirmation = new_password

    if @user.save
      if @user.approved
        @user.send_reset_password_instructions
      end

      redirect_to edit_admin_user_path(@user), notice: "User created and activation email sent!"
    else
      @affiliates = Affiliate.all
      render :new
    end
  end

  # DELETE /users
  def destroy
    load_user
  end

  # GET /users/1/edit
  def edit
    load_user
    @body_class = 'toolkit USER'
    @header_navigation = true
    @affiliates = Affiliate.all
  end

  # GET /users
  def index
    @approved = User.includes(:affiliate).approved
    @unapproved = User.includes(:affiliate).unapproved
    @rejected = User.includes(:affiliate).rejected
    authorize @approved
  end

  # GET /users/new
  def new
    @user = User.new
    authorize @user
    @affiliates = Affiliate.all
  end

  # GET /users/1
  def show
    load_user
    @affiliates = Affiliate.all
  end

  # PATCH /users/1
  def update
    load_user
    account_status = set_account_status

    if @user.update_attributes!(user_params)
      unless account_status == 'same'
        @user.send_account_notification(account_status)
      end

      redirect_to edit_admin_user_path(@user), notice: "User updated!"
    else
      @body_class = 'toolkit USER'
      @header_navigation = true
      @affiliates = Affiliate.all

      render :edit, notice: "There was a problem updating the user."
    end
  end

  private

  def load_user
    @user = User.includes(:affiliate).find(params[:id])
    authorize @user
  end

  def set_account_status
    if !@user.approved? && params[:user][:approved] == '1'
      'approved'
    elsif params[:user][:approved] == '0' && @user.approved?
      'unapproved'
    elsif !@user.rejected? && params[:user][:rejected] == '1'
      'rejected'
    else
      'same'
    end
  end

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :approved, :rejected, :zip_code, :affiliate_id, :department,
      :local_number, :title, :cell_phone, :receive_alerts, :role, :custom_branding, :vetter_region
    )
  end
end