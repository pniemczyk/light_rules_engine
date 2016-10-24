module LightRulesEngine
  module Operators
    class Lt
      def self.result(*args)
        args[0] < args[1]
      end
    end
  end
end
