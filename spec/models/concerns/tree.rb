require 'rails_helper'

RSpec.shared_examples "Tree" do
  let!(:klass) { record.class }

  describe "Associations" do
    it "belongs_to parent" do
      expect(record).to respond_to(:parent)
    end
    
    it "has_many children" do
      expect(record).to respond_to(:children)
    end
  end

  describe "Class Methods" do
    describe ".roots" do
      it "returns records that have no parent_id" do
        expect(klass.roots).to include record
      end
    end
    
    describe ".root" do
      it "returns the first root" do
        expect(klass.root).to eq klass.roots.first
      end
    end
  end

  # Hierarchy: record => child => grandchild / sibling
  describe "Instance Methods" do
    let!(:child)      { record.dup }
    let!(:grandchild) { record.dup }
    let!(:sibling)    { record.dup }

    before(:each) do
      child.update_attributes!(title: "Child", parent_id: record.id)
      grandchild.update_attributes!(title: "Grandchild", parent_id: child.id)
      sibling.update_attributes!(title: "Sibling", parent_id: child.id)
    end

    describe "#ancestors" do
      it "returns an array of ancestors" do
        expect(grandchild.ancestors).to eq [child, record]
      end
    end

    describe "#path" do
      it "returns an array of ancestors" do
        expect(grandchild.path).to eq "/Never Quit/Child/Grandchild"
      end
    end

    describe "#root" do
      it "returns the root ancestor" do
        expect(grandchild.root).to eq record
      end
    end

    describe "#siblings" do
      it "returns records with the same parent_id" do
        expect(grandchild.siblings).to eq [sibling]
      end
    end

    describe "#self_and_siblings" do
      it "returns records with the same parent_id and self" do
        expect(grandchild.self_and_siblings).to include sibling
        expect(grandchild.self_and_siblings).to include grandchild
      end
    end
  end
end
