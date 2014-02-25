require 'rubygems'
require 'money'
require 'active_support/core_ext/array/extract_options'

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

  def self.append_features(receiver)

    receiver.instance_eval do

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

  end

end
