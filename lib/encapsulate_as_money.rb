require "encapsulate_as_money/version"
require "money"
require "active_support/core_ext/array/extract_options"

module EncapsulateAsMoney
  def encapsulate_as_money(*fields)
    options = fields.extract_options!
    fields.each { |field| encapsulate_as_money!(field, options[:preserve_nil]) }
  end

private

  def encapsulate_as_money!(field, preserve_nil)
    define_method field do
      if preserve_nil
        Money.new(super()) if super()
      else
        Money.new(super() || 0)
      end
    end

    define_method "#{field}=" do |money|
      super(money.try(:cents))
    end
  end
end
