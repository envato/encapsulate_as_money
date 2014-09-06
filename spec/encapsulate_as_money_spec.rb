# encoding: utf-8
require "spec_helper"

describe EncapsulateAsMoney do

  Given(:model_base_class_with_attr) {
    Class.new {
      extend EncapsulateAsMoney
      attr_accessor :attribute
    }
  }
  Given(:model_instance) { model_class.new }

  describe "encapsulating the attribute as money" do
    When(:model_class) {
      Class.new(model_base_class_with_attr) {
        encapsulate_as_money :attribute
      }
    }

    describe "reading" do
      Given!(:init_attr_value) { model_instance.instance_variable_set :@attribute, initial_attr_value }

      context "initial value is nil" do
        Given(:initial_attr_value) { nil }
        Then { model_instance.attribute == Money.zero }
      end

      context "initial value is 0" do
        Given(:initial_attr_value) { 0 }
        Then { model_instance.attribute == Money.zero }
      end

      context "initial value is 1" do
        Given(:initial_attr_value) { 1 }
        Then { model_instance.attribute == Money.new(1) }
      end
    end

    describe "writing" do

      context "a value of $1" do
        When { model_instance.attribute = Money.new(1_00) }
        Then { model_instance.instance_variable_get(:@attribute) == 1_00 }
      end

      context "a value of $0" do
        When { model_instance.attribute = Money.zero }
        Then { model_instance.instance_variable_get(:@attribute) == 0 }
      end

      context "a value of nil" do
        When { model_instance.attribute = nil }
        Then { model_instance.instance_variable_get(:@attribute) == 0 }
      end
    end
  end

  describe "encapsulating the attribute as money, preserving nil" do
    When(:model_class) {
      Class.new(model_base_class_with_attr) {
        encapsulate_as_money :attribute, :preserve_nil => true
      }
    }

    describe "reading" do
      Given!(:init_attr_value) { model_instance.instance_variable_set :@attribute, initial_attr_value }

      context "initial value is nil" do
        Given(:initial_attr_value) { nil }
        Then { model_instance.attribute == nil }
      end

      context "initial value is 0" do
        Given(:initial_attr_value) { 0 }
        Then { model_instance.attribute == Money.zero }
      end

      context "initial value is 1" do
        Given(:initial_attr_value) { 1 }
        Then { model_instance.attribute == Money.new(1) }
      end
    end

    describe "writing" do

      context "a value of $1" do
        When { model_instance.attribute = Money.new(1_00) }
        Then { model_instance.instance_variable_get(:@attribute) == 1_00 }
      end

      context "a value of $0" do
        When { model_instance.attribute = Money.zero }
        Then { model_instance.instance_variable_get(:@attribute) == 0 }
      end

      context "a value of nil" do
        When { model_instance.attribute = nil }
        Then { model_instance.instance_variable_get(:@attribute).nil? }
      end
    end
  end

  describe "encapsulating the attribute as money, defining currency AUD" do
    When(:model_class) {
      Class.new(model_base_class_with_attr) {
        encapsulate_as_money :attribute, :currency => :aud
      }
    }

    describe "reading" do
      Given!(:init_attr_value) { model_instance.instance_variable_set :@attribute, initial_attr_value }

      context "initial value is nil" do
        Given(:initial_attr_value) { nil }
        Then { model_instance.attribute == Money.new(0, :aud) }
      end

      context "initial value is 0" do
        Given(:initial_attr_value) { 0 }
        Then { model_instance.attribute == Money.new(0, :aud) }
      end

      context "initial value is 1" do
        Given(:initial_attr_value) { 1 }
        Then { model_instance.attribute == Money.new(1, :aud) }
      end
    end

    describe "writing" do

      context "a value of NZD $1" do
        When(:result) { model_instance.attribute = Money.new(1_00, :nzd) }
        Then { expect(result).to have_failed(EncapsulateAsMoney::CurrencyMismatchError, /Must be a quantity of AUD, received NZD/) }
      end

      context "a value of AUD $1" do
        When { model_instance.attribute = Money.new(1_00, :aud) }
        Then { model_instance.instance_variable_get(:@attribute) == 1_00 }
      end

      context "a value of nil" do
        When { model_instance.attribute = nil }
        Then { model_instance.instance_variable_get(:@attribute) == 0 }
      end
    end
  end
end
