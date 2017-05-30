class Admin::MiscController < AdminController
  # GET /admin
  def home
    raise Pundit::NotAuthorizedError unless AdminPolicy.new(current_user, nil).admin_home?
  end
end
