require 'light_rules_engine/version'

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

    class All
      def self.result(*args)
        args.all?
      end
    end

    class Any
      def self.result(*args)
        args.any?
      end
    end

    class Gt
      def self.result(*args)
        args[0] > args[1]
      end
    end

    class Lt
      def self.result(*args)
        args[0] < args[1]
      end
    end

    class Eq
      def self.result(*args)
        args.all? { |x| x == args[0] }
      end
    end

    class Range
      def self.result(*args)
        from  = args[0]
        to    = args[1]
        value = args[2]
        from <= value && to >= value
      end
    end
  end

  ALL_CONSTS = { 'THE_NUMBER' => 1 }.freeze

  class ValueResolver
    def initialize(data_provider:, operation_context_class:)
      @data_provider           = data_provider
      @operation_context_class = operation_context_class
    end

    def resolve(value)
      kind = value[:kind]
      send("process_#{kind}", value)
    end

    private

    attr_reader :operation_context_class, :data_provider

    def process_operator(value)
      operation_context_class.new(value, data_provider).result
    end

    def process_data(value)
      data_provider.value_for(value[:type])
    end

    def process_const(value)
      ALL_CONSTS[value[:value]]
    end

    def process_value(value)
      value[:value]
    end
  end

  class OperatorContxt
    def initialize(operator_hash, data_provider)
      @operator_hash = operator_hash
      @data_provider = data_provider
    end

    def operator
      @operator ||= Operators.find(operator_hash[:type])
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
      ValueResolver.new(data_provider: data_provider, operation_context_class: self.class).resolve(value)
    end
  end

  class DataProvider
    def initialize(data)
      @data = data
    end

    def value_for(keyword)
      send_methods = keyword.split('.').compact
      send_methods.inject(data) do |object, m|
        arg_var_one = m[/\(.*?\)/]
        arg_var_two = m[/\[.*?\]/]
        arg = (arg_var_one || arg_var_two)
        m.gsub!(arg.to_s, '')
        next unless object.respond_to?(m)
        next object.public_send(m) unless arg
        arg.delete!("\"'[()]")
        next object.public_send(m, arg) if arg_var_one
        arg = Integer(arg) rescue arg
        object.public_send(m).public_send(:[], arg)
      end
    end

    private

    attr_reader :data
  end

  class Processor
    def initialize(data_container:, conditions:)
      @data_container = data_container
      @conditions     = conditions
    end

    def applable?
      return false unless conditions[:kind] == :operator
      OperatorContxt.new(conditions, data_provider).result
    end

    private

    attr_reader :data_container, :conditions

    def data_provider
      @data_provider ||= DataProvider.new(data_container)
    end
  end
end
