class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  around_action :set_current_user

  protected

  def set_current_user
    User.current_user = User.first
    yield
    User.current_user = nil
  end
end
 