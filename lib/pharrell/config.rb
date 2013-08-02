module Pharrell
  class Config
    def initialize
      @map = {}
    end

    def bind(klass, arg = nil, &blk)
      if blk
        @map[klass] = blk
      else
        @map[klass] = arg
      end
    end

    def instance_for(klass)
      instance_or_class = @map[klass]

      if instance_or_class.is_a? Class
        instance_or_class.new
      elsif instance_or_class.is_a? Proc
        instance_or_class.call
      else
        instance_or_class
      end
    end
  end
end

