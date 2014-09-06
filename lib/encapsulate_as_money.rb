# encoding: utf-8
require "money"
require "encapsulate_as_money/version"
require "encapsulate_as_money/money_definition"
require "encapsulate_as_money/currency_definition"
require "encapsulate_as_money/options"

module EncapsulateAsMoney

  def encapsulate_as_money(*attributes)
    options = Options.extract(attributes)
    money_def = MoneyDefinition.build(options)
    currency_def = CurrencyDefinition.build(options)

    attributes.each do |attribute|

      define_method attribute do
        options = { :value => super(), :attribute => attribute }
        money_def.read(options.merge(:currency => currency_def.read(options)))
      end

      define_method "#{attribute}=" do |money|
        options = { :money => money, :attribute => attribute }
        currency_def.write(options)
        super(money_def.write(options))
        money
      end

    end
  end
end
