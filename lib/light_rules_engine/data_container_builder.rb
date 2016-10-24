module LightRulesEngine
  class DataContainerBuilder
    def self.build(object, name: nil)
      return object.clone unless name
      Struct.new(name.to_sym).new(object.clone)
    end
  end
end
