class Users::RegistrationsController < Devise::RegistrationsController
  def confirmation
  end

  def edit
    load_user
  	@body_class = 'toolkit profile'
  	@header_navigation = true
    @affiliates = Affiliate.all
  end

  def password
    load_user
  end

  def update_password
    load_user
    # puts "\n\n\n#{params['user'].inspect}\n\n\n"
    if params['user']['password'] == params['user']['password_confirmation']
      @user.password = params['user']['password']
      @user.password_confirmation = params['user']['password_confirmation']
      if @user.update(password_params)
        bypass_sign_in(@user)
        redirect_to profile_path, notice: "Password changed!"
      else
        redirect_to profile_path, notice: "There was a problem changing your password"
      end
    else
      redirect_to profile_path, notice: "Password and confirmation must match."
    end
  end

  protected

  def after_sign_up_path_for(resource)
    confirmation_path
  end

  def after_inactive_sign_up_path_for(resource)
    confirmation_path
  end

  private

  def load_user
    @user = current_user
    authorize @user, pundit_policy
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # UserPolicy has policies for both this controller and Admin::UsersController.
  # Some of the actions overlap, so to differentiate the two, devise_ is prepended
  # for policies in this controller.
  def pundit_policy
    "devise_#{params[:action]}?"
  end

end