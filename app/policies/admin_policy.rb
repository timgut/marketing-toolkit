class AdminPolicy < ApplicationPolicy
  def admin_home?
    current_user_is_admin?
  end
end
