require 'rails_helper'

RSpec.describe Folder, type: :model do
  let!(:user) { create(:user) }

  let!(:flyer_root) { user.root_flyer_folder }
  let!(:image_root) { user.root_image_folder }

  let!(:flyer_child) { create(:folder, name: "flyer-child", path: "/flyer-child", user: user, parent: flyer_root) }

  let!(:flyer_grandchild1) { create(:folder, name: "flyer-grandchild1", path: "/flyer-child/flyer-grandchild1", user: user, parent: flyer_child) }
  let!(:flyer_grandchild2) { create(:folder, name: "flyer-grandchild2", path: "/flyer-child/flyer-grandchild2", user: user, parent: flyer_child) }


  describe "Folder.roots" do
    it "returns the root folders" do
      expect(Folder.roots).to include flyer_root
      expect(Folder.roots).to include image_root
    end
  end

  describe "#ancestors" do
    it "returns every parent" do
      expect(flyer_grandchild1.ancestors).to include flyer_child
      expect(flyer_grandchild1.ancestors).to include flyer_root
    end
  end

  describe "#root" do
    it "returns the root parent" do
      expect(flyer_grandchild1.root).to eq flyer_root
    end
  end

  describe "#siblings" do
    it "returns every sibling" do
      expect(flyer_grandchild1.siblings.map(&:id)).to include flyer_grandchild2.id
    end
  end

  describe "#self_and_siblings" do
    it "returns every sibling and self" do
      expect(flyer_grandchild1.self_and_siblings.map(&:id)).to include flyer_grandchild1.id
      expect(flyer_grandchild1.self_and_siblings.map(&:id)).to include flyer_grandchild2.id
    end
  end
end
