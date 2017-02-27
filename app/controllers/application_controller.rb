class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  around_action :set_current_user

  layout :layout_by_resource

  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected

  def set_current_user
    User.current_user = User.first
    yield
    User.current_user = nil
  end

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :zip_code, :council, :local_number, :title, :cell_phone, :receive_alerts])
  end

  #https://github.com/plataformatec/devise/wiki/How-To:-Create-custom-layouts
  def layout_by_resource
  	if devise_controller?
  		"devise"
  	else
  		"application"
  	end
  end
end
 