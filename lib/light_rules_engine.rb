require 'light_rules_engine/version'
require 'light_rules_engine/data_provider'
require 'light_rules_engine/value_resolver'
require 'light_rules_engine/operator_contxt'
require 'light_rules_engine/operators'
require 'light_rules_engine/config'
require 'light_rules_engine/conditions_applicable_checker'
require 'light_rules_engine/data_container_builder'
require 'light_rules_engine/base_rule'

module LightRulesEngine
  def self.config
    @config || Config::DEFAULT_CONFIG
  end

  def self.setup_config(opts = {})
    @config = Config::DEFAULT_CONFIG.merge(opts)
  end

  def self.applicable_conditions?(data_container, conditions)
    ConditionsApplicableChecker.new(data_container: data_container, conditions: conditions).applable?
  end

  def rules_applicable?(data_container, *rules)
    rules.map do |rule|
      rule if rules_applicable?(data_container, rule.conditions)
    end.compact
  end
end
