module Pharrell
  class Config
    def initialize(definition)
      @definition = definition
      rebuild!
    end

    def instance_for(klass)
      @bindings[klass].call
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
          options = arg.kind_of?(Hash) ? arg : {}
          @bindings[klass] = blk
        else
          obj_block = if arg.kind_of?(Class)
            Proc.new { arg.new }
          else
            Proc.new { arg }
          end

          @bindings[klass] = obj_block
        end
      end
    end
  end
end

