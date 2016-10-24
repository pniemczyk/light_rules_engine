module LightRulesEngine
  class BaseRule
    def initialize(conditions:, source:)
      @conditions = conditions
      @source     = source
    end

    attr_reader :source, :conditions
  end
end
