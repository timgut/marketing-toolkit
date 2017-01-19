require 'rails_helper'

RSpec.describe Flyer, type: :model do
  let(:campaign) { create(:campaign) }
  let(:template) { create(:template) }
  let(:flyer)    { create(:flyer, template: template) }

  # Seed data
  before(:each) do
    campaign_flyer = create(:campaign_flye, campaign: campaign, flyer: flyer)

    data = [
      create(:data, flyer: flyer, key: "headline", value: "You never quit. That’s why we never rest."),
      create(:data, flyer: flyer, key: "quote", value: "\"I'm proud of the work I do to make my community better. I couldn't do it without my union.\""),
      create(:data, flyer: flyer, key: "attribution", value: "Clerical"),
    ]
  end

  describe "#method_missing" do
    it "retrieves flyer data from the data table" do
      expect(flyer.headline).to eq "You never quit. That’s why we never rest."
    end
  end
end
