require 'rails_helper'

RSpec.describe Datum, type: :model do
  let!(:datum) { create(:datum) }

  describe "Associations" do
    it "belongs_to document" do
      expect(datum).to respond_to(:document)
    end
  end

  describe "Scopes" do
  end

  describe "Validations" do
    it "validates_presence_of document, key" do
      expect { invalid = Datum.create!(document: nil) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { invalid = Datum.create!(key: nil)      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "Concerns" do
  end

  describe "Class Methods" do
  end

  describe "Instance Methods" do
  end
end
