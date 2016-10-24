module LightRulesEngine
  module Operators
    class All
      def self.result(*args)
        args.all?
      end
    end
  end
end
