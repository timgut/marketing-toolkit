class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :assign_categories

  layout :layout_by_resource

  protected

  def assign_categories
    @categories = Category.all
  end

  def alert_message
    "There was a problem. Please try again."
  end

  private

  def after_sign_out_path_for(resource_or_scope)
    unauthenticated_root_path
  end

  def configure_permitted_parameters
    # :role and :approved are intentionally omitted from this controller; only admins users should be able to modify those
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :zip_code, :council, :local_number, :title, :cell_phone, :receive_alerts, :region, :department, :affiliate_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :zip_code, :council, :local_number, :title, :cell_phone, :receive_alerts, :region, :department, :affiliate_id])
  end


  # https://github.com/plataformatec/devise/wiki/How-To:-Create-custom-layouts
  def layout_by_resource
  	if devise_controller? 
      if params[:controller] == 'users/registrations' and (params[:action] == 'edit' or params[:action] == 'password')
        "application"
      else
    		"devise"
      end
  	else
  		"application"
  	end
  end

  def user_not_authorized
    flash[:alert] = "
      You cannot
      #{params[:action].singularize.sub('show', 'view').sub('home', 'view').sub('stat','view')}
      this
      #{params[:controller].split('/').first.singularize.sub('admin', 'page')}.
    "

    redirect_back fallback_location: authenticated_root_path
  end

  def paginate(collection)
    params[:page] ||= 1

    case collection
    when ActiveRecord::Relation
      collection.page(params[:page])
    when Array
      Kaminari.paginate_array(collection).page(params[:page])
    end
  end
end
 