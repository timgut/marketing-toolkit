require 'rails_helper'

RSpec.describe Campaign, type: :model do
  let!(:campaign) { create(:campaign) }

  describe "Associations" do
    it "has_many templates" do
      expect(campaign).to respond_to(:templates)
    end
  end

  describe "Scopes" do
  end

  describe "Validations" do
    it "validates the presence of title" do
      expect { invalid = Campaign.create!(title: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "Concerns" do
    it_behaves_like "Status" do
      let!(:record) { campaign }
    end
    
    it_behaves_like "Tree" do
      let!(:record) { campaign }
    end
  end

  describe "Class Methods" do
  end

  describe "Instance Methods" do
  end
end
