module LightRulesEngine
  module Operators
    class Eq
      def self.result(*args)
        args.all? { |x| x == args[0] }
      end
    end
  end
end
