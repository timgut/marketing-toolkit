class UserPolicy < ApplicationPolicy
  METHODS = [:edit?, :password?, :update_password?]
  ADMIN_METHODS = [:create?, :destroy?, :edit?, :index?, :show?, :update?]

  METHODS.each do |action|
    define_method action do
      record_is_current_user?
    end
  end

  ADMIN_METHODS.each do |action|
    define_method action do
      current_user_is_admin_or_vetter?
    end
  end
end
