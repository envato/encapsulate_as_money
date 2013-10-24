require 'rubygems'
require 'money'

def Money(cents)
  cents.is_a?(String) ? cents.gsub(',', '').to_money : Money.new(cents)
end

class Money
  # let us go like this: -Money(10_00) to get Money(-10_00), awesome :)
  def -@
    Money(-cents)
  end
end

module EncapsulateAsMoney
  def encapsulate_as_money(*fields)
    fields.each { |field| encapsualte_as_money!(field) }
  end

  private

  def encapsualte_as_money!(field)
    define_method(field) do
      Money((super() || 0))
    end

    define_method("#{field}=") do |money|
      super(money.cents)
    end
  end
end
