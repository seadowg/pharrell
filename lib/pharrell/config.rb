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
            Proc.new { |config|
              if arg.respond_to?(:__pharrell_constructor_classes)
                args = arg.__pharrell_constructor_classes.map do |klass|
                  config.instance_for(klass)
                end
              
                arg.new(*args)
              else
                arg.new
              end
            }
          else
            Proc.new { arg }
          end

          @bindings[klass] = obj_block
        end
      end
    end
  end
end

