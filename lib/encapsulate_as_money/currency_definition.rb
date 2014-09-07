# encoding: utf-8
module EncapsulateAsMoney
  class CurrencyMismatchError < RuntimeError; end

  class CurrencyDefinition
    class << self
      def build(options = {})
        return options[:currency_def] if options[:currency_def]
        options[:currency] ? StaticCurrencyDefinition.new(options[:currency]) : default_currency_def
      end

      private

      def default_currency_def
        @default_currency_def ||= DefaultCurrencyDefinition.new
      end
    end

    def read(args = {})
    end

    def write(args = {})
    end
  end

  class StaticCurrencyDefinition < CurrencyDefinition
    def initialize(currency)
      @currency = currency
    end

    def read(args = {})
      @currency
    end

    def write(args = {})
      if args[:money] && args[:money].currency.id.upcase != read.upcase
        raise CurrencyMismatchError.new(
          "Must be a quantity of #{read.upcase}, received #{args[:money].currency.id.upcase}"
        )
      end
    end
  end

  class DefaultCurrencyDefinition < CurrencyDefinition
    def read(args = {})
      Money.default_currency.id
    end

    def write(args = {})
      if args[:money] && args[:money].currency.id.upcase != read.upcase
        raise CurrencyMismatchError.new(
          "Must be a quantity of #{read.upcase}, received #{args[:money].currency.id.upcase}"
        )
      end
    end
  end
end
