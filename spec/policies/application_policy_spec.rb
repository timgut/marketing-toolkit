require 'rails_helper'

describe ApplicationPolicy, type: :class do
  let(:campaign) { create(:campaign) }
  let(:template) { create(:template) }
  let(:document) { create(:document, template_id: template.id) }

  let!(:user) { create(:user) }

  # This method raises an error, so ignore it.
  before(:each) do
    create(:campaign_template, campaign: campaign, template: template)
    allow_any_instance_of(User).to receive(:send_admin_emails).and_return(nil)
  end

  context "With a Campaign" do
    let!(:policy) { ApplicationPolicy.new(user, campaign) }

    it "grants access if the user has access to the campaign" do
      CampaignUser.create!(campaign_id: campaign.id, user_id: user.id)
      expect(policy.current_user_can_access_campaign?).to eq true
    end

    it "denies access if the user does not have access to the campaign" do
      user.campaigns.destroy_all
      expect(policy.current_user_can_access_campaign?).to eq false
    end
  end

  context "With a Document" do
    context "With a persisted Document" do
      let!(:policy) { ApplicationPolicy.new(user, document) }

      it "grants access if the user has access to the template's campaign" do
        CampaignUser.create!(campaign_id: campaign.id, user_id: user.id)
        CampaignTemplate.create!(campaign_id: campaign.id, template_id: template.id)
        expect(policy.current_user_can_access_campaign?).to eq true
      end

      it "denies access if the user does not have access to the template's campaign" do
        user.campaigns.destroy_all
        expect(policy.current_user_can_access_campaign?).to eq false
      end
    end

    context "With a new Document" do
      let!(:policy) { ApplicationPolicy.new(user, Document.new(template_id: template.id)) }

      it "grants access if the user has access to the template's campaign" do
        CampaignUser.create!(campaign_id: campaign.id, user_id: user.id)
        CampaignTemplate.create!(campaign_id: campaign.id, template_id: template.id)
        expect(policy.current_user_can_access_campaign?).to eq true
      end

      it "denies access if the user does not have access to the template's campaign" do
        user.campaigns.destroy_all
        expect(policy.current_user_can_access_campaign?).to eq false
      end
    end
  end

  context "With a Template" do
    let!(:policy) { ApplicationPolicy.new(user, template) }

    it "grants access if the user has access to the template's campaign" do
      CampaignUser.create!(campaign_id: campaign.id, user_id: user.id)
      CampaignTemplate.create!(campaign_id: campaign.id, template_id: template.id)
      expect(policy.current_user_can_access_campaign?).to eq true
    end

    it "denies access if the user does not have access to the template's campaign" do
      user.campaigns.destroy_all
      expect(policy.current_user_can_access_campaign?).to eq false
    end
  end
end
