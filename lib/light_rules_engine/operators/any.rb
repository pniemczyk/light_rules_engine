module LightRulesEngine
  module Operators
    class Any
      def self.result(*args)
        args.any?
      end
    end
  end
end
