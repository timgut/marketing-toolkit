require 'rails_helper'

describe CampaignPolicy, type: :class do
  let!(:policy)   { described_class   }
  let!(:campaign) { create(:campaign) }

  let!(:user)   { create(:user)   }
  let!(:vetter) { create(:vetter) }
  let!(:admin)  { create(:admin)  }

  CampaignPolicy::ADMIN_METHODS.each do |action|
    permissions action do
      it "denies access if the user is not an admin" do
        expect(policy).not_to permit(user, campaign)
        expect(policy).not_to permit(vetter, campaign)
      end

      it "grants access if the user is an admin" do
        expect(policy).to permit(admin, campaign)
      end
    end
  end

  permissions :current_user_can_access_campaign? do
    before(:each) { CampaignUser.destroy_all }

    it "denies access if the user does not have a join table record" do
      expect(policy).not_to permit(user, campaign)
    end

    it "grants access if the user has a join table record" do
      CampaignUser.create!(campaign: campaign, user: user)
      expect(policy).to permit(user, campaign)
    end
  end
end
