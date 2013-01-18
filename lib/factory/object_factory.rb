module Factory
  class ObjectFactory
    def self.new class_name
      if class_name.classname?
        class_eval "#{class_name}.new"
      else
        default_object.new
      end
    end

    def self.default_object
      Object
    end
  end
end