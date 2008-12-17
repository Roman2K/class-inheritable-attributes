module ClassInheritableAttributes
  class << self
    def eval_in_accessor_module(klass, code)
      mod = klass.instance_eval { @_inheritable_attribute_accessors ||= Module.new }
      klass.extend(mod)
      mod.module_eval(code)
    end
    
    def fetch_value(klass, attribute)
      each_parent(klass) do |parent|
        if values = registry[parent] and values.key?(attribute)
          return values[attribute]
        elsif parent.instance_variable_defined?("@#{attribute}")
          return parent.instance_variable_get("@#{attribute}")
        end
      end
      return nil
    end
    
    def store_value(klass, attribute, value)
      if Thread.current == Thread.main
        if value.nil?
          klass.instance_eval do
            remove_instance_variable("@#{attribute}") if instance_variable_defined?("@#{attribute}")
          end
        else
          klass.instance_variable_set("@#{attribute}", value)
        end
      else
        registry[klass] ||= {}
        if value.nil?
          registry[klass].delete(attribute)
          registry.delete(klass) if registry[klass].empty?
        else
          registry[klass][attribute] = value
        end
      end
    end
    
  private
    
    def each_parent(klass)
      while klass < Object
        yield klass
        klass = klass.superclass
      end
    end
    
    def registry
      Thread.current[ClassInheritableAttributes.name] ||= {}
    end
  end
  
  def class_inheritable_attr_reader(*attributes)
    attributes.each do |attribute|
      ClassInheritableAttributes.eval_in_accessor_module(self, <<-EOS)
        def #{attribute}
          #{ClassInheritableAttributes}.fetch_value(self, :#{attribute})
        end
      EOS
    end
  end
  
  def class_inheritable_attr_writer(*attributes)
    attributes.each do |attribute|
      ClassInheritableAttributes.eval_in_accessor_module(self, <<-EOS)
        def #{attribute}=(value)
          #{ClassInheritableAttributes}.store_value(self, :#{attribute}, value)
        end
      EOS
    end
  end
  
  def class_inheritable_attr_accessor(*attributes)
    class_inheritable_attr_reader(*attributes)
    class_inheritable_attr_writer(*attributes)
  end
end

Class.class_eval do
  include ClassInheritableAttributes
end
