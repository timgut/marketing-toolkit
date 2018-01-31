require 'rails_helper'

describe DocumentPolicy, type: :class do
  let!(:policy)   { described_class }
  let!(:document) { create(:document, creator: user) }

  let!(:user)   { create(:user)   }
  let!(:vetter) { create(:vetter) }
  let!(:admin)  { create(:admin)  }

  DocumentPolicy::METHODS.each do |action|
    permissions action do
      it "denies access if the user is not an admin or does not own the document" do
        expect(policy).not_to permit(vetter, document)
      end

      it "grants access if the user is an admin or owns the document" do
        expect(policy).to permit(admin, document)
        expect(policy).to permit(user, document)
      end
    end
  end

  permissions :current_user_can_access_campaign? do
    let!(:campaign) { create(:campaign) }
    before(:each) { CampaignUser.destroy_all }

    it "denies access if the user does not have a join table record" do
      expect(policy).not_to permit(user, document)
    end

    it "grants access if the user has a join table record" do
      document.template.update_attributes!(campaign_id: campaign.id)
      CampaignUser.create!(campaign: campaign, user: user)
      expect(policy).to permit(user, document)
    end
  end
end
