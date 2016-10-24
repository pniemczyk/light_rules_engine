module LightRulesEngine
  class Config
    DEFAULT_CONSTS = {
      RULE_ENGINE: 'LightRulesEngine'
    }.freeze

    DEFAULT_CONFIG = {
      data_provider_class: LightRulesEngine::DataProvider,
      operators_namespace: LightRulesEngine::Operators,
      operation_context_class: LightRulesEngine::OperatorContxt,
      value_resolver_class: LightRulesEngine::ValueResolver,
      consts: DEFAULT_CONSTS
    }.freeze
  end
end
