require 'rubygems'
require 'money'
require 'active_support/core_ext/array/extract_options'

def Money(cents)
  if cents.is_a? String
    warn "[DEPRECATION] Money(String) is deprecated. Please use Money.parse(String) instead. (#{Kernel.caller.first})"
    Money.parse(cents.gsub(',', ''))
  else
    Money.new(cents)
  end
end

class Money
  # let us go like this: -Money(10_00) to get Money(-10_00), awesome :)
  def -@
    Money(-cents)
  end
end

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
