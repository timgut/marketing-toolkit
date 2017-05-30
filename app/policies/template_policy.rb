class TemplatePolicy < ApplicationPolicy
  METHODS = [:show?]
  ADMIN_METHODS = [:create?, :destroy?, :edit?, :index?, :update?]

  METHODS.each do |action|
    define_method action do
      record_is_published?
    end
  end

  ADMIN_METHODS.each do |action|
    define_method action do
      current_user_is_admin?
    end
  end
end