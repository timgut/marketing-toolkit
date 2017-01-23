require 'rails_helper'

RSpec.describe Campaign, type: :model do
  let!(:campaign) { create(:campaign) }

  describe "Concerns" do
    it_behaves_like "Status" do
      let!(:record) { campaign }
    end
  end
end
