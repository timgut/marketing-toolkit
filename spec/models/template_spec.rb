require 'rails_helper'

RSpec.describe Template, type: :model do
  let!(:template) { create(:template) }

  describe "Concerns" do
    it_behaves_like "Status" do
      let!(:record) { template }
    end
  end
end
