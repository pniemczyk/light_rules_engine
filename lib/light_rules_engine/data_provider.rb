module LightRulesEngine
  class DataProvider
    ReturningValueError = Class.new(StandardError)

    def initialize(data)
      @data = data
    end

    def value_for(keyword)
      send_methods(keyword).inject(data, &method(:call_chain_methods))
    rescue => ex
      raise ReturningValueError, "Error during returning #{keyword}, details: #{ex.message}"
    end

    private

    attr_reader :data

    def send_methods(keyword)
      keyword.split('.').compact
    end

    def call_chain_methods(object, method_name)
      state = method_state(method_name)
      return nil unless object.respond_to?(state[:method_name])
      case state[:kind]
      when :pure   then object.public_send(state[:method_name])
      when :round  then object.public_send(state[:method_name], state[:arg])
      when :square then object.public_send(state[:method_name]).public_send(:[], state[:arg])
      end
    end

    def method_state(method_name)
      arg_var_one = method_name[/\(.*?\)/]
      arg_var_two = method_name[/\[.*?\]/]
      arg         = (arg_var_one || arg_var_two)
      method_name = method_name.gsub!(arg.to_s, '')
      return { method_name: method_name, kind: :pure } unless arg
      return { method_name: method_name, kind: :square, arg: prepare_arg(arg) } if arg_var_two
      { method_name: method_name, kind: :round, arg: prepare_arg(arg) }
    end

    def prepare_arg(arg)
      arg.delete!("\"'[()]")
      Integer(arg)
    rescue
      arg[0] == ':' ? arg[1..-1].to_sym : arg
    end
  end
end
