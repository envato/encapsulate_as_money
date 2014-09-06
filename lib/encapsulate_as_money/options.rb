# encoding: utf-8
module EncapsulateAsMoney
  module Options
    def self.extract(args)
      args.last.is_a?(Hash) ? args.pop : {}
    end
  end
end
