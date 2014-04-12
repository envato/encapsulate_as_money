require "encapsulate_as_money/version"
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
    define_method attribute do
      if preserve_nil
        Money.new(super()) if super()
      else
        Money.new(super() || 0)
      end
    end

    define_method "#{attribute}=" do |money|
      super(money && money.cents)
    end
  end

  def extract_options(args)
    args.last.is_a?(Hash) ? args.pop : {}
  end
end
