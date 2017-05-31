class CategoryPolicy < ApplicationPolicy
  ADMIN_METHODS = [:create?, :destroy?, :edit?, :index?, :show?, :update?]

  ADMIN_METHODS.each do |action|
    define_method action do
      current_user_is_admin?
    end
  end
end
