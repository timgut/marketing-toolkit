class Admin::UsersController < AdminController
  # POST /admin/users
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
      @affiliates = Affiliate.order(:state,:title)
      render :new
    end
  end

  # GET /admin/users/1/edit
  def edit
    load_user
    @body_class        = 'toolkit USER'
    @header_navigation = true

    @affiliates    = Affiliate.order(:state,:title)
    @all_campaigns = Campaign.publish
    @template_ids  = @user.documents.map(&:template_id)
    @templates     = Template.find(@template_ids.uniq)
  end

  # GET /admin/users/export.csv
  def export
    respond_to do |format|
      format.csv { send_data User.to_csv, filename: "users-#{DateTime.now.to_i}.csv" }
    end
  end

  # GET /admin/users
  def index
    @approved = User.includes(:affiliate).approved
    @unapproved = User.includes(:affiliate).unapproved
    @rejected = User.includes(:affiliate).rejected
    authorize @approved
  end

  # GET /admin/users/new
  def new
    @user = User.new
    authorize @user
    @affiliates = Affiliate.order(:state,:title)
  end

  # PATCH /admin/users/1
  def update
    load_user

    if params[:quiet_rejection] == '1'
      @user.quiet = true
      params[:user][:rejected] = '1'
    end  

    account_status = set_account_status

    if @user.update_attributes(user_params)
      if params[:campaigns]
        @user.set_accessible_campaigns!(params[:campaigns])
      end
      
      if account_status != 'same'
        @user.send_account_notification(account_status)
      end

      redirect_to edit_admin_user_path(@user), notice: "User updated!"
    else
      @body_class = 'toolkit USER'
      @header_navigation = true
      @affiliates = Affiliate.order(:state,:title)

      redirect_to edit_admin_user_path(@user), notice: "There was a problem updating the user."
    end
  end

  # GET /admin/users/1/workspace
  def workspace
    @user = User.find(params[:id])
    @documents = paginate(@user.documents)
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