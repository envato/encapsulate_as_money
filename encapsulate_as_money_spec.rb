# encoding: utf-8
require 'spec_helper'

class Base
  include EncapsulateAsMoney
  attr_accessor :zero_amount, :nonzero_amount, :nil_amount
end

class NilDestroyingExample < Base
  encapsulate_as_money :zero_amount, :nonzero_amount, :nil_amount
end

class NilPreservingExample < Base
  encapsulate_as_money :zero_amount, :nonzero_amount, :nil_amount, :preserve_nil => true
end


describe EncapsulateAsMoney do

  describe Money do
    it 'creates a Money object without using `new` (?!?)' do
      expect(Money(1_00)).to eq Money.new(1_00)
    end

    context 'parse from string' do
      ['$10.00', '10.00', '$10', '10'].each do |pretty_string|
        specify { expect(Money(pretty_string)).to eq Money.new(10_00) }
      end

      specify { expect(Money('$10,000.00')).to eq Money.new(10000_00) }
    end
  end

  describe EncapsulateAsMoney do
    let(:nil_amount) { nil }
    let(:zero_amount) { 0 }
    let(:nonzero_amount) { 1_00 }

    before do
      product.instance_variable_set(:@nil_amount, nil_amount)
      product.instance_variable_set(:@zero_amount, zero_amount)
      product.instance_variable_set(:@nonzero_amount, nonzero_amount)
    end

    context 'dont preserve nil values' do
      let(:product) { NilDestroyingExample.new }

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
      let(:product) { NilPreservingExample.new }

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
end
