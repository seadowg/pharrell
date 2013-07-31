module Pharrell
  @@configs = {}
  @@config = nil

  def self.instance_for(klass)
    @@configs[@@config].instance_for(klass)
  end

  def self.config(name, &blk)
    @@configs[name] = Config.new
    blk.call(@@configs[name])
  end

  def self.use_config(name)
    @@config = name
  end

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
