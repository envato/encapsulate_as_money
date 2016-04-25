# encoding: utf-8
require "encapsulate_as_money/version"
require "encapsulate_as_money/activemodel_integration"
require "money"

module EncapsulateAsMoney
  def encapsulate_as_money(*attributes)
    options = extract_options(attributes)
    attributes.each do |attribute|
      encapsulate_attribute_as_money(attribute, options[:preserve_nil])
    end
  end

private

  def encapsulate_attribute_as_money(attribute, preserve_nil = true)
    if preserve_nil
      define_method attribute do
        Money.new(super()) if super()
      end

      define_method "#{attribute}=" do |money|
        super(money && money.fractional)
      end
    else
      define_method attribute do
        Money.new(super() || 0)
      end

      define_method "#{attribute}=" do |money|
        num = (money && money.fractional) || 0
        super(num)
      end
    end
  end

  def extract_options(args)
    args.last.is_a?(Hash) ? args.pop : {}
  end
end
