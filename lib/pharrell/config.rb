module Pharrell
  class Config
    def initialize
      @bindings = {}
    end

    def bind(klass, arg = nil, &blk)
      if blk
        options = arg.kind_of?(Hash) ? arg : {}
        @bindings[klass] = ObjectGenerator.new(blk, options)
      else
        obj_block = if arg.kind_of?(Class)
          Proc.new { arg.new }
        else
          Proc.new { arg }
        end

        @bindings[klass] = ObjectGenerator.new(obj_block)
      end
    end

    def instance_for(klass)
      @bindings[klass].fetch
    end

    def rebuild!
      @bindings.each do |key, value|
        value.invalidate!
      end
    end

    private

    class ObjectGenerator
      def initialize(blk, options = {})
        @blk = blk
        @options = options
      end

      def fetch
        if @options[:cache]
          @value ||= @blk.call
        else
          @blk.call
        end
      end

      def invalidate!
        @value = nil
      end
    end
  end
end

