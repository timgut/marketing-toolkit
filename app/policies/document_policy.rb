class DocumentPolicy < ApplicationPolicy
  METHODS = [:destroy?, :download?, :duplicate?, :edit?, :restore?, :trash?, :update?]

  METHODS.each do |action|
    define_method action do
      current_user_is_owner_or_admin?
    end
  end
end
