# encoding: utf-8
require "encapsulate_as_money/version"
require "money"

module EncapsulateAsMoney
  class CurrencyMismatchError < RuntimeError; end

  def encapsulate_as_money(*attributes)
    options = extract_options(attributes)
    attributes.each do |attribute|
      encapsulate_attribute_as_money(attribute, options[:currency], options[:preserve_nil])
    end
  end

private

  def encapsulate_attribute_as_money(attribute, currency, preserve_nil = true)
    currency = currency || Money.default_currency.id
    if preserve_nil
      define_method attribute do
        Money.new(super(), currency) if super()
      end

      define_method "#{attribute}=" do |money|
        if money && money.currency.id.upcase != currency.upcase
          raise CurrencyMismatchError.new("Must be a quantity of #{currency.upcase}, received #{money.currency.id.upcase}")
        end
        super(money && money.fractional)
      end
    else
      define_method attribute do
        Money.new(super() || 0, currency)
      end

      define_method "#{attribute}=" do |money|
        if money && money.currency.id.upcase != currency.upcase
          raise CurrencyMismatchError.new("Must be a quantity of #{currency.upcase}, received #{money.currency.id.upcase}")
        end
        num = (money && money.fractional) || 0
        super(num)
      end
    end
  end

  def extract_options(args)
    args.last.is_a?(Hash) ? args.pop : {}
  end
end
