class Admin::MiscController < AdminController
  before_action :admin_auth

  # GET /admin
  def home
  end

  # GET /admin/stats
  def stats
    @non_admins  = User.includes(:documents, :images).where("role != 'Administrator'")
    @templates   = Template.includes(:documents, documents: [:creator]).all
    @departments = @non_admins.map(&:department).uniq
  end

  protected

  def admin_auth
    raise Pundit::NotAuthorizedError unless AdminPolicy.new(current_user, nil).admin_home?
  end
end
