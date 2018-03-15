require 'rails_helper'

describe TemplatePolicy, type: :class do
  let!(:policy)   { described_class }
  let!(:template) { create(:template) }

  let!(:user)   { create(:user)   }
  let!(:vetter) { create(:vetter) }
  let!(:admin)  { create(:admin)  }

  TemplatePolicy::METHODS.each do |action|
    permissions action do
      it "denies access if the template is not published" do
        template.update_attributes!(status: 0)

        [user, vetter, admin].each do |role|
          expect(policy).not_to permit(role, template)
        end
      end

      it "grants access if the template is published" do
        [user, vetter, admin].each do |role|
          expect(policy).to permit(role, template)
        end
      end
    end
  end

  TemplatePolicy::ADMIN_METHODS.each do |action|
    permissions action do
      it "denies access if the user is not an admin" do
        expect(policy).not_to permit(user, template)
        expect(policy).not_to permit(vetter, template)
      end

      it "grants access if the user is an admin" do
        expect(policy).to permit(admin, template)
      end
    end
  end

  permissions :current_user_can_access_campaign? do
    let!(:campaign) { create(:campaign) }
    let!(:ct)       { create(:campaign_template, campaign: campaign, template: template)}

    before(:each) { CampaignUser.destroy_all }

    it "denies access if the user does not have a join table record" do
      expect(policy).not_to permit(user, template)
    end

    it "grants access if the user has a join table record" do
      CampaignUser.create!(campaign: campaign, user: user)
      expect(policy).to permit(user, template)
    end
  end
end
