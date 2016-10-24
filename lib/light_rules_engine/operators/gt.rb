module LightRulesEngine
  module Operators
    class Gt
      def self.result(*args)
        args.each_with_index do |arg, idx|
          return false if idx.positive? && arg > args[idx.pred]
        end
        true
      end
    end
  end
end
