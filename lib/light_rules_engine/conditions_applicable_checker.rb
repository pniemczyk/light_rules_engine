module LightRulesEngine
  class ConditionsApplicableChecker
    def initialize(data_container:, conditions:)
      @data_container = data_container
      @conditions     = conditions
    end

    def applable?
      return false unless conditions[:kind] == :operator
      config[:operation_context_class].new(conditions, data_provider).result
    end

    private

    attr_reader :data_container, :conditions

    def config
      @config ||= LightRulesEngine.config
    end

    def data_provider
      @data_provider ||= config[:data_provider_class].new(data_container)
    end
  end
end
