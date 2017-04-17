class AdminController < ApplicationController
  def require_admin
    unless current_user && current_user.approved? && current_user.admin?
      flash[:notice] = "You are trying to reach a restricted area."
      redirect_to authenticated_root_path
    end
  end
end
