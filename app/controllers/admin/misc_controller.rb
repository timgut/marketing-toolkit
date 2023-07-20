class Admin::MiscController < AdminController
  before_action :admin_auth

  # GET /admin/documentation
  def documentation
    render layout: false
  end
  
  # GET /admin/documentation/mini_magick
  def mini_magick
    render layout: false
  end


  # GET /admin
  def home
    @documents = Document.includes(:creator, :template).newest.rendered.limit(50)
  end

  # GET /admin/stats
  def stats
    @admins      = User.where("role = 'Administrator' or role = 'Vetter'")
    @non_admins  = User.includes(:documents, :images).where("role != 'Administrator'")
    @templates   = Template.includes(:documents, documents: [:creator]).all
    @departments = @non_admins.map(&:department).uniq.compact

    # Counts
    @num_documents = DocumentUser.where.not(user_id: @admins.map(&:id)).count
    @num_images    = ImageUser.where.not(user_id: @admins.map(&:id)).count
  end

  protected

  def admin_auth
    raise Pundit::NotAuthorizedError unless AdminPolicy.new(current_user, nil).admin_home?
  end
end
