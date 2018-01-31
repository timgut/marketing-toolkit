require 'rails_helper'

RSpec.describe CampaignUser, type: :model do
  describe "Functionality" do
    let!(:user1) { create(:user) }
    let!(:campaign1) { create(:campaign) }
    let!(:campaign2) { create(:campaign) }

    it "users have campaigns" do
      CampaignUser.create!(campaign: campaign1, user: user1)
      expect(user1.campaigns).to include campaign1
      expect(user1.campaigns).not_to include campaign2
    end
  end
end
