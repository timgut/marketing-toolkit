class ImagePolicy < ApplicationPolicy
  METHODS = [:crop?, :destroy?, :edit?, :restore?, :show?, :trash?, :update?]

  METHODS.each do |action|
    define_method action do
      current_user_is_owner_or_admin?
    end
  end
end
