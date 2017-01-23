require 'rails_helper'

RSpec.describe Flyer, type: :model do
  let!(:campaign) { create(:campaign) }
  let!(:template) { create(:template) }
  let!(:flyer) { create(:flyer, template: template) }
  let!(:campaign_flyer) { create(:campaign_flyer, campaign: campaign, flyer: flyer) }
  let!(:data) {[
    create(:datum, flyer: flyer, key: "headline", value: "You never quit. That’s why we never rest."),
    create(:datum, flyer: flyer, key: "quote", value: "\"I'm proud of the work I do to make my community better. I couldn't do it without my union.\""),
    create(:datum, flyer: flyer, key: "attribution", value: "Clerical")
  ]}

  before(:each){ flyer.reload }

  describe "Concerns" do
    it_behaves_like "Status" do
      let!(:record) { flyer }
    end
  end

  describe "#define_data_methods" do
    it "creates methods for each datum" do
      expect(flyer.respond_to?(:headline)).to eq true
      expect(flyer.headline).to eq "You never quit. That’s why we never rest."

      expect(flyer.respond_to?(:quote)).to eq true
      expect(flyer.quote).to eq "\"I'm proud of the work I do to make my community better. I couldn't do it without my union.\""

      expect(flyer.respond_to?(:attribution)).to eq true
      expect(flyer.attribution).to eq "Clerical"
    end
  end
end
