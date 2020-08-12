class DocumentPolicy < ApplicationPolicy
  METHODS = [:destroy?, :download?, :duplicate?, :edit?, :job_status?, :restore?, :trash?, :update?, :preview?]

  METHODS.each do |action|
    define_method action do
      current_user_is_owner_or_admin?
    end
  end
end
