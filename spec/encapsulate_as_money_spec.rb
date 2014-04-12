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

    # it 'casts non zero integer values to a money instance' do
    Then { product.nonzero_amount == Money.new(1_00) }

    # it 'casts zero integer values to a money instance' do
    Then { product.zero_amount == Money.new(0) }

    # it 'casts nil into a zero money instance' do
    Then { product.nil_amount == Money.new(0) }
  end

  context 'preserve nil values' do
    let(:product) { nil_preserving_example.new }

    # it 'casts non zero integer values to a money instance' do
    Then { product.nonzero_amount == Money.new(1_00) }

    # it 'casts zero integer values to a money instance' do
    Then { product.zero_amount == Money.new(0) }

    # it 'preserves nil' do
    Then { product.nil_amount == nil }
  end
end
