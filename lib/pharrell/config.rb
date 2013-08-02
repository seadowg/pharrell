module Pharrell
  class Config
    def initialize
      @map = {}
    end

    def bind(klass, instance_or_class)
      @map[klass] = instance_or_class
    end

    def instance_for(klass)
      instance_or_class = @map[klass]

      if (instance_or_class.is_a? Class)
        instance_or_class.new
      else
        instance_or_class
      end
    end
  end
end

