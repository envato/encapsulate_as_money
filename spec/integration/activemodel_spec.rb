require 'spec_helper'

describe "ActiveModel integration", skip: !ENV['APPRAISAL_INITIALIZED'] && !ENV['TRAVIS'] do
  describe '.validates_inclusion_of' do
    it "validates money correctly" do
      expect(Price.new(amount: Money.new(0))).not_to be_valid
      expect(Price.new(amount: Money.new(1))).to be_valid
      expect(Price.new(amount: Money.new(2))).to be_valid
      expect(Price.new(amount: Money.new(3))).not_to be_valid
    end

    it "validates numbers correctly" do
      expect(Price.new(qty: 0)).not_to be_valid
      expect(Price.new(qty: 1)).to be_valid
      expect(Price.new(qty: 2)).to be_valid
      expect(Price.new(qty: 3)).not_to be_valid
    end
  end
end
