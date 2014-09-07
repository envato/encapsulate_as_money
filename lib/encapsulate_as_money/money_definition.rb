# encoding: utf-8
module EncapsulateAsMoney

  class MoneyDefinition
    class << self
      def build(options = {})
        options[:preserve_nil] ? preserving_nil_numeric_def : non_preserving_nil_numeric_def
      end

      private

      def preserving_nil_numeric_def
        @preserving_nil_numeric_def ||= PreservingNilNumericMoneyDefinition.new
      end

      def non_preserving_nil_numeric_def
        @non_preserving_nil_numeric_def ||= NonPreservingNilNumericMoneyDefinition.new
      end
    end

    def read(args = {})
    end

    def write(args = {})
    end
  end

  class PreservingNilNumericMoneyDefinition < MoneyDefinition
    def read(args = {})
      Money.new(args[:value], args[:currency]) if args[:value]
    end

    def write(args = {})
      args[:money] && args[:money].fractional
    end
  end

  class NonPreservingNilNumericMoneyDefinition < MoneyDefinition
    def read(args = {})
      Money.new(args[:value] || 0, args[:currency])
    end

    def write(args = {})
      (args[:money] && args[:money].fractional) || 0
    end
  end
end
