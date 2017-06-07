require 'rails_helper'

describe AdminPolicy, type: :class do
  let!(:policy) { described_class }
  let!(:user)   { create(:user)   }
  let!(:vetter) { create(:vetter) }
  let!(:admin)  { create(:admin)  }

  permissions :admin_home? do
    it "denies access if the user is not an admin" do
      expect(policy).not_to permit(user, AdminPolicy.new(user, nil))
      expect(policy).not_to permit(vetter, AdminPolicy.new(vetter, nil))
    end

    it "grants access if the user is an admin" do
      expect(policy).to permit(admin, AdminPolicy.new(admin, nil))
    end
  end
end
