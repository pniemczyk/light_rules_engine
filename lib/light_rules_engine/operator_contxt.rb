module LightRulesEngine
  class OperatorContxt
    def initialize(operator_hash, data_provider)
      @operator_hash = operator_hash
      @data_provider = data_provider
    end

    def operator
      @operator ||= config[:operators_namespace].find(operator_hash[:type])
    end

    def values
      operator_hash[:values].map(&method(:resolve))
    end

    def result
      operator.result(*values)
    end

    private

    attr_reader :operator_hash, :data_provider

    def resolve(value)
      config[:value_resolver_class].new(data_provider: data_provider).resolve(value)
    end

    def config
      @config ||= LightRulesEngine.config
    end
  end
end
