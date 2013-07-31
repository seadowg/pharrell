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

    def bind(klass, instance)
      @map[klass] = instance
    end

    def instance_for(klass)
      @map[klass]
    end
  end
end
