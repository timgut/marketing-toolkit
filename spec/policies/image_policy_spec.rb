require 'rails_helper'

describe ImagePolicy, type: :class do
  let!(:policy) { described_class }
  let!(:image)  { create(:image, creator: user) }

  let!(:user)   { create(:user)   }
  let!(:vetter) { create(:vetter) }
  let!(:admin)  { create(:admin)  }

  ImagePolicy::METHODS.each do |action|
    permissions action do
      it "denies access if the user is not an admin or does not own the image" do
        expect(policy).not_to permit(vetter, image)
      end

      it "grants access if the user is an admin or owns the image" do
        expect(policy).to permit(admin, image)
        expect(policy).to permit(user, image)
      end
    end
  end
end
