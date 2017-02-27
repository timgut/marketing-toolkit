class Users::RegistrationsController < Devise::RegistrationsController

  def after_sign_up_path_for(resource)
    confirmation_path
  end

  def index
    ## manages users screen: http://toolkit.afscme.bytrilogy.com/users
  end

  def applications
    if current_user && current_user.admin?
      @users = User.unapproved
      @header_navigation = true
      @body_class = "toolkit application-queue"
      render "users/applications"
    else
      flash[:notice] = "You are trying to reach a restricted area."
      redirect_to authenticated_root_path 
    end
  end


  def show
  	## just show the view
  end

  def edit
  	@body_class = 'toolkit profile'
  	@header_navigation = true
  end

end