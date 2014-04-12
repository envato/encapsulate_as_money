# encoding: utf-8
require "spec_helper"

describe EncapsulateAsMoney do
  let(:base_example) do
    Class.new {
      extend EncapsulateAsMoney
      attr_accessor :zero_amount, :nonzero_amount, :nil_amount
    }
  end

  let(:nil_destroying_example) do
    Class.new(base_example) {
      encapsulate_as_money :zero_amount, :nonzero_amount, :nil_amount
     }
  end

  let(:nil_preserving_example) do
    Class.new(base_example) {
      encapsulate_as_money :zero_amount, :nonzero_amount, :nil_amount, :preserve_nil => true
    }
  end

  let(:nil_amount) { nil }
  let(:zero_amount) { 0 }
  let(:nonzero_amount) { 1_00 }

  before do
    product.instance_variable_set(:@nil_amount, nil_amount)
    product.instance_variable_set(:@zero_amount, zero_amount)
    product.instance_variable_set(:@nonzero_amount, nonzero_amount)
  end

  context 'dont preserve nil values' do
    let(:product) { nil_destroying_example.new }

    it 'casts non zero integer values to a money instance' do
      expect(product.nonzero_amount).to eq Money.new(1_00)
    end

    it 'casts zero integer values to a money instance' do
      expect(product.zero_amount).to eq Money.new(0_00)
    end

    it 'casts nil into a zero money instance' do
      expect(product.nil_amount).to eq Money.new(0_00)
    end
  end

  context 'preserve nil values' do
    let(:product) { nil_preserving_example.new }

    it 'casts non zero integer values to a money instance' do
      expect(product.nonzero_amount).to eq Money.new(1_00)
    end

    it 'casts zero integer values to a money instance' do
      expect(product.zero_amount).to eq Money.new(0_00)
    end

    it 'preserves nil' do
      expect(product.nil_amount).to eq nil
    end
  end
end
