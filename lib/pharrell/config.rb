module Pharrell
  class Config
    def initialize(definition)
      @definition = definition
      rebuild!
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

    def instance_for(klass)
      @bindings[klass].call
    end

    def rebuild!
      @bindings = {}
      @definition.call(self)
    end
  end
end

