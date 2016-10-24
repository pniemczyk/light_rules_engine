require 'light_rules_engine/operators/all'
require 'light_rules_engine/operators/any'
require 'light_rules_engine/operators/gt'
require 'light_rules_engine/operators/lt'
require 'light_rules_engine/operators/eq'
require 'light_rules_engine/operators/range'

module LightRulesEngine
  module Operators
    UnknownOperator = Class.new(StandardError)
    def self.find(name)
      class_name = classify_string(name.to_s)
      raise(UnknownOperator, name) unless operators_namespaces.const_defined?(class_name)
      operators_namespaces.const_get(class_name)
    end

    def self.operators_namespaces
      LightRulesEngine.config[:operators_namespace]
    end

    def self.classify_string(string)
      string = string.sub(/^[a-z\d]*/) { $&.capitalize }
      string.gsub(%r{/(?:_|(\/))([a-z\d]*)/}) { "#{$1}#{$2.capitalize}" }.gsub('/', '::') # rubocop:disable Style/PerlBackrefs
      string.sub(/.*\./, '')
    end
  end
end
