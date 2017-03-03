class Users::RegistrationsController < Devise::RegistrationsController

  def after_sign_up_path_for(resource)
    confirmation_path
  end

  def show
  	## just show the view
  end

  def edit
  	@body_class = 'toolkit profile'
  	@header_navigation = true
    @user = User.current_user || current_user
  end

end