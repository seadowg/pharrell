require 'pharrell/config'
require 'pharrell/injectable'
require 'pharrell/constructor'

module Pharrell
  class BindingNotFoundError < Exception
    def message
      "Binding could not be found!"
    end
  end
  
  class ConfigNotDefinedError < Exception
    def message
      "Config has not been defined!"
    end
  end
  
  @@configs = {}
  @@config = nil

  def self.config(name, opts = {}, &blk)
    if opts[:extends]
      @@configs[name] = @@configs[opts[:extends]].extend(blk)
    else
      @@configs[name] = Config.new(blk)
    end
  end

  def self.use_config(name)
    @@config = name
    rebuild!
  end

  def self.instance_for(klass)
    current_config.instance_for(klass)
  end

  def self.rebuild!
    current_config.rebuild!
  end
  
  def self.reset!
    @@configs = {}
    @@config = nil
  end

  private

  def self.current_config
    config = @@configs[@@config]
    
    if config
      config
    else
      raise ConfigNotDefinedError
    end
  end
end
