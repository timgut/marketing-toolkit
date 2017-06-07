require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { create(:user) }

  describe "Associations" do
    it "has_and_belongs_to_many documents" do
      expect(user).to respond_to(:documents)
    end

    it "has_and_belongs_to_many images" do
      expect(user).to respond_to(:images)
    end

    it "belongs_to affiliate" do
      expect(user).to respond_to(:affiliate)
    end
  end
  
  describe "Validations" do
  end

  describe "Scopes" do
    describe ".approved" do
      it "returns approved users" do
        user.update_attributes!(approved: true)
        new_user = create(:user, approved: false)

        expect(User.approved).to include user
        expect(User.approved).not_to include new_user
      end
    end

    describe ".unapproved" do
      it "returns approved users" do
        user.update_attributes!(approved: false, rejected: false)
        new_user = create(:user, approved: true)

        expect(User.unapproved).to include user
        expect(User.unapproved).not_to include new_user
      end
    end

    describe ".rejected" do
      it "returns approved users" do
        user.update_attributes!(rejected: true)
        new_user = create(:user, rejected: false)

        expect(User.rejected).to include user
        expect(User.rejected).not_to include new_user
      end
    end

    describe ".approvers" do
      it "returns approved users" do
        user.update_attributes!(role: "Vetter")
        new_user = create(:user, role: "User")

        expect(User.approvers).to include user
        expect(User.approvers).not_to include new_user
      end
    end
  end

  describe "Concerns" do
  end

  describe "Class Methods" do
  end

  describe "Instance Methods" do
  end
end
