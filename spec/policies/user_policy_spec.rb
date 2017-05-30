require 'rails_helper'

describe UserPolicy, type: :class do
  let!(:policy) { described_class }
  let!(:user)   { create(:user)   }
  let!(:vetter) { create(:vetter) }
  let!(:admin)  { create(:admin)  }

  # @user = current_user is set in Users::RegistrationsController, so these
  # specs won't test anything of value anyway. If the way users are loaded
  # changes in that controller, then these specs should be made to pass.
  UserPolicy::METHODS.each do |action|
    permissions action do
      it "denies access if @user is not current_user" do
        [user, vetter, admin].each do |role|
          expect(policy).not_to permit(role, nil)
        end
      end

      it "grants access if @user is current_user" do
        [user, vetter, admin].each do |role|
          expect(policy).to permit(role, role)
        end
      end
    end
  end

  UserPolicy::ADMIN_METHODS.each do |action|
    permissions action do
      it "denies access if the user is not an admin or vetter" do
        expect(policy).not_to permit(user, user)
      end

      it "grants access if the user is an admin or vetter" do
        expect(policy).to permit(admin, admin)
        expect(policy).to permit(vetter, vetter)
      end
    end
  end
end
