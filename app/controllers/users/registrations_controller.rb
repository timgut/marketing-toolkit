class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.

  def confirmation
  end

  def edit
    load_user
  	@body_class = 'toolkit profile'
  	@header_navigation = true
    @affiliates = Affiliate.order(:state,:title)
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

  def check_captcha
    unless verify_recaptcha
      self.resource = resource_class.new sign_up_params
      resource.validate # Look for any other validation errors besides reCAPTCHA
      flash[:recaptcha_error] = "reCAPTCHA test failed. You must confirm you are not a robot."
      redirect_back fallback_location: new_user_registration_path
    end 
  end

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