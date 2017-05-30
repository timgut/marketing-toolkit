class ApplicationPolicy
  attr_reader :current_user, :record

  def initialize(user, record)
    @current_user = user
    @record = record
  end

  def scope
    Pundit.policy_scope!(current_user, record.class)
  end

  class Scope
    attr_reader :current_user, :scope

    def initialize(user, scope)
      @current_user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  private

  def current_user_is_owner_or_admin?
    current_user_is_admin? || @record.creator_id == @current_user.id
  end

  def current_user_is_admin_or_vetter?
    current_user_is_admin? || current_user_is_vetter?
  end

  def current_user_is_admin?
    @current_user.admin?
  end

  def current_user_is_vetter?
    @current_user.vetter?
  end

  def record_is_current_user?
    @record == @current_user
  end

  def record_is_published?
    @record&.status == "publish"
  end
end
