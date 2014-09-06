# encoding: utf-8
module EncapsulateAsMoney
  class CurrencyMismatchError < RuntimeError; end

  class CurrencyDefinition
    def self.build(options = {})
      StaticCurrencyDefinition.new(options[:currency] || Money.default_currency.id)
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
