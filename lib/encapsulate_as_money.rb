# encoding: utf-8
require "encapsulate_as_money/version"
require "money"

module EncapsulateAsMoney
  class CurrencyMismatchError < RuntimeError; end

  def encapsulate_as_money(*attributes)
    options = extract_options(attributes)
    money_def = if options[:preserve_nil]
                  PreservingNilNumericMoneyDefinition.new
                else
                  NonPreservingNilNumericMoneyDefinition.new
                end
    currency_def = StaticCurrencyDefinition.new(options[:currency] || Money.default_currency.id)
    attributes.each do |attribute|
      encapsulate_attribute_as_money(attribute, money_def, currency_def)
    end
  end

  private

  def encapsulate_attribute_as_money(attribute, money_def, currency_def) 
    define_method attribute do
      options = { :value => super(), :attribute => attribute }
      money_def.read(options.merge(:currency => currency_def.read(options)))
    end

    define_method "#{attribute}=" do |money|
      options = { :money => money, :attribute => attribute }
      currency_def.write(options)
      super(money_def.write(options))
      money
    end
  end

  def extract_options(args)
    args.last.is_a?(Hash) ? args.pop : {}
  end

  class PreservingNilNumericMoneyDefinition
    def read(args = {})
      Money.new(args[:value], args[:currency]) if args[:value]
    end

    def write(args = {})
      args[:money] && args[:money].fractional
    end
  end

  class NonPreservingNilNumericMoneyDefinition
    def read(args = {})
      Money.new(args[:value] || 0, args[:currency])
    end

    def write(args = {})
      (args[:money] && args[:money].fractional) || 0
    end
  end

  class StaticCurrencyDefinition
    def initialize(currency)
      @currency = currency
    end

    def read(args = {})
      @currency
    end

    def write(args = {})
      if args[:money] && args[:money].currency.id.upcase != @currency.upcase
        raise CurrencyMismatchError.new(
          "Must be a quantity of #{@currency.upcase}, received #{args[:money].currency.id.upcase}"
        )
      end
    end
  end
end
