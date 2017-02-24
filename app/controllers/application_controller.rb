class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  around_action :set_current_user

  layout :layout_by_resource

  protected

  def set_current_user
    User.current_user = User.first
    yield
    User.current_user = nil
  end

  private
  #https://github.com/plataformatec/devise/wiki/How-To:-Create-custom-layouts
  def layout_by_resource
  	if devise_controller?
  		"devise"
  	else
  		"application"
  	end
  end
end
 