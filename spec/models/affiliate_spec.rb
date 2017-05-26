require 'rails_helper'

RSpec.describe Affiliate, type: :model do
  let!(:affiliate){ create(:affiliate) }

  describe "Associations" do
    it "has many users" do
      expect(affiliate).to respond_to(:users)
    end
  end

  describe "Scopes" do
  end

  describe "Validations" do
    it "validates the presence of title, region, state, and slug" do
      expect { invalid = Affiliate.create!(title: nil,  region: "1", slug: "IU", region: "N/A") }.to raise_error(ActiveRecord::RecordInvalid)
      expect { invalid = Affiliate.create!(title: "IU", region: nil, slug: "IU", region: "N/A") }.to raise_error(ActiveRecord::RecordInvalid)
      expect { invalid = Affiliate.create!(title: "IU", region: "3", slug: nil,  region: "N/A") }.to raise_error(ActiveRecord::RecordInvalid)
      expect { invalid = Affiliate.create!(title: "IU", region: "4", slug: "IU", region: nil)   }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "Concerns" do
  end

  describe "Class Methods" do
  end

  describe "Instance Methods" do
    describe "#to_s" do
      context "without an abbrevitaion" do
        it "displays the correct string" do
          expect(affiliate.to_s).to eq affiliate.title
        end
      end

      context "with an abbreviation" do
        it "displays the correct string" do
          affiliate.update_attributes!(state: "Alabama")
          expect(affiliate.reload.to_s).to eq "AL - #{affiliate.title}"
        end
      end
    end
  end
end
