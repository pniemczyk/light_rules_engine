module LightRulesEngine
  class DataContainerBuilder
    def self.build(object, name = nil)
      return object.dup unless name
      Struct.new(name.to_sym).new(object.dup)
    end
  end
end
