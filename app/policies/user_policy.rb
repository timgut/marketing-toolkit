class UserPolicy < ApplicationPolicy
  USER_METHODS       = [:devise_edit?, :devise_password?, :devise_update_password?]
  ADMIN_METHODS      = [:create?, :destroy?, :index?, :show?, :new?]
  ACCESSIBLE_METHODS = [:edit?, :update?]

  USER_METHODS.each do |action|
    define_method action do
      record_is_current_user?
    end
  end

  ADMIN_METHODS.each do |action|
    define_method action do
      current_user_is_admin_or_vetter?
    end
  end

  ACCESSIBLE_METHODS.each do |action|
    define_method action do
      current_user_is_admin_or_vetter? || record_is_current_user?
    end
  end
end
