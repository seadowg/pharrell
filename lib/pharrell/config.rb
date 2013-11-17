module Pharrell
  class Config
    def initialize(definition)
      @definition = definition
      rebuild!
    end

    def instance_for(klass)
      @bindings[klass].call(self)
    end

    def rebuild!
      @bindings =  Binder.new.tap { |b|
        @definition.call(b)
      }.bindings
    end

    def extend(definition)
      agg_definition = proc { |binder| 
        @definition.call(binder)
        definition.call(binder) 
      }
      
      Config.new(agg_definition)
    end

    private

    class Binder
      attr_reader :bindings

      def initialize
        @bindings = {}
      end

      def bind(klass, arg = nil, &blk)
        if blk
          @bindings[klass] = blk
        else
          obj_block = if arg.kind_of?(Class)
            Proc.new { |config| build_instance(arg, config)}
          else
            Proc.new { arg }
          end

          @bindings[klass] = obj_block
        end
      end
      
      private
      
      def build_instance(target_klass, config)
        if target_klass.respond_to?(:__pharrell_constructor_classes)
          args = target_klass.__pharrell_constructor_classes.map do |arg_klass|
            config.instance_for(arg_klass)
          end
        
          target_klass.new(*args)
        else
          target_klass.new
        end
      end
    end
  end
end

