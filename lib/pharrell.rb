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
  
  class InvalidOptionsError < Exception
    def initialize(opts)
      @opts = opts
    end
    
    def message
      "Invalid options: #{@opts.join(" ")}"
    end
  end
  
  @@configs = {}
  @@config = nil

  def self.config(name, opts = {}, &blk)
    check_options([:extends], opts)
    
    if opts[:extends]
      @@configs[name] = fetch_config(opts[:extends]).extend(blk)
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
    fetch_config(@@config)
  end
  
  def self.fetch_config(name)
    config = @@configs[name]
    
    if config
      config
    else
      raise ConfigNotDefinedError
    end
  end
  
  def self.check_options(opts, opt_hash)
    extra_keys = opt_hash.keys.reject { |key| opts.include?(key) }
    
    if extra_keys.empty?
      true
    else
      raise InvalidOptionsError.new(extra_keys)
    end
  end
end
