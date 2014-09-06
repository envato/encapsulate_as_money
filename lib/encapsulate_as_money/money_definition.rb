# encoding: utf-8
module EncapsulateAsMoney

  class MoneyDefinition
    class << self
      def build(options = {})
        options[:preserve_nil] ? preserving_nil_numeric_definition : non_preserving_nil_numeric_definition
      end

      private

      def preserving_nil_numeric_definition
        @preserving_nil_numeric_definition ||= PreservingNilNumericMoneyDefinition.new
      end

      def non_preserving_nil_numeric_definition
        @non_preserving_nil_numeric_definition ||= NonPreservingNilNumericMoneyDefinition.new
      end
    end
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
end
