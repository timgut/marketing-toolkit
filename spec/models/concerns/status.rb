require 'rails_helper'

RSpec.shared_examples "Status" do
  describe "Scopes" do
    describe ".archive" do
      it "returns archived #{described_class.to_s.downcase.pluralize}" do
        record.archive!
        expect(described_class.__send__(:archive)).to include record
      end
    end

    describe ".draft" do
      it "returns draft #{described_class.to_s.downcase.pluralize}" do
        record.draft!
        expect(described_class.__send__(:draft)).to include record
      end
    end

    describe ".publish" do
      it "returns published #{described_class.to_s.downcase.pluralize}" do
        record.publish!
        expect(described_class.__send__(:publish)).to include record
      end
    end
  end
end
