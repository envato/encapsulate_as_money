require 'spec_helper'

describe "ActiveModel integration", skip: !ENV['APPRAISAL_INITIALIZED'] do
  describe '.validates_inclusion_of' do
    it "validates money correctly" do
      expect(Price.new(Money.new(0))).not_to be_valid
      expect(Price.new(Money.new(1))).to be_valid
      expect(Price.new(Money.new(2))).to be_valid
      expect(Price.new(Money.new(3))).not_to be_valid
    end
  end
end
