require 'light_rules_engine/operators/all'
require 'light_rules_engine/operators/any'
require 'light_rules_engine/operators/gt'
require 'light_rules_engine/operators/lt'
require 'light_rules_engine/operators/eq'
require 'light_rules_engine/operators/range'

module LightRulesEngine
  module Operators
    def self.find(name)
      class_name = classify_string(name.to_s)
      self.const_get(class_name)
    end

    def self.classify_string(string)
      string = string.sub(/^[a-z\d]*/) { $&.capitalize }
      string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
      string.sub(/.*\./, '')
    end
  end
end
