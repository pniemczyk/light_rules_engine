module LightRulesEngine
  class ValueResolver
    def initialize(data_provider:)
      @data_provider = data_provider
    end

    def resolve(value)
      kind = value[:kind]
      send("process_#{kind}", value)
    end

    private

    attr_reader :data_provider

    def process_operator(value)
      config[:operation_context_class].new(value, data_provider).result
    end

    def process_data(value)
      data_provider.value_for(value[:type])
    end

    def process_const(value)
      config[:consts][value[:value]]
    end

    def process_value(value)
      value[:value]
    end

    def config
      @config ||= LightRulesEngine.config
    end
  end
end
