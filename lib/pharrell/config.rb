module Pharrell
  class Config
    def initialize
      @map = {}
    end

    def bind(klass, arg = nil, &blk)
      if blk
        options = arg.kind_of?(Hash) ? arg : {}
        @map[klass] = ObjectGenerator.new(options, &blk)
      else
        @map[klass] = arg
      end
    end

    def instance_for(klass)
      instance_or_class = @map[klass]

      if instance_or_class.is_a? Class
        instance_or_class.new
      elsif instance_or_class.is_a? ObjectGenerator
        instance_or_class.fetch
      else
        instance_or_class
      end
    end

    def rebuild!
      @map.each do |key, value|
        if value.is_a? ObjectGenerator
          value.invalidate!
        end
      end
    end

    private

    class ObjectGenerator
      def initialize(options = {}, &blk)
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

