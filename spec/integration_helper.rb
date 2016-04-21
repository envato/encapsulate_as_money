require 'active_model'

class Price
  extend EncapsulateAsMoney

  case ActiveModel::VERSION::MAJOR
  when 3 then include ActiveModel::AttributeMethods
  when 4 then include ActiveModel::Model
  else raise NotImplementedError, ActiveModel::VERSION::MAJOR
  end

  include ActiveModel::Validations

  encapsulate_as_money :amount
  validates_inclusion_of :amount, in: Money.new(1)..Money.new(2)

  def initialize(amount)
    @amount = amount
  end

  def amount
    @amount
  end

  def amount=(amount)
    @amount = amount
  end
end
