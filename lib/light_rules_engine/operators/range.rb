module LightRulesEngine
  module Operators
    class Range
      def self.result(*args)
        from  = args[0]
        to    = args[1]
        value = args[2]
        from <= value && to >= value
      end
    end
  end
end
