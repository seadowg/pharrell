require 'pharrell/config'
require 'pharrell/injectable'
require 'pharrell/constructor'
require 'pharrell/errors'

module Pharrell
  @@environment = nil

  def self.config(name, opts = {}, &blk)
    environment.config(name, opts, &blk)
  end

  def self.use_config(name)
    environment.use_config(name)
  end

  def self.instance_for(klass)
    environment.instance_for(klass)
  end

  def self.rebuild!
    environment.rebuild!
  end

  def self.reset!
    environment.reset!
  end

  private

  def self.environment
    @@enironment ||= Environment.new
  end

  class Environment
    @configs = {}
    @config = nil

    def config(name, opts = {}, &blk)
      check_options([:extends], opts)

      if opts[:extends]
        @configs[name] = fetch_config(opts[:extends]).extend(blk)
      else
        @configs[name] = Config.new(blk)
      end
    end

    def use_config(name)
      @config = name
      rebuild!
    end

    def instance_for(klass)
      current_config.instance_for(klass)
    end

    def rebuild!
      current_config.rebuild!
    end

    def reset!
      @configs = {}
      @config = nil
    end

    private

    def current_config
      fetch_config(@config)
    end

    def fetch_config(name)
      config = @configs[name]

      if config
        config
      else
        raise ConfigNotDefinedError
      end
    end

    def check_options(opts, opt_hash)
      extra_keys = opt_hash.keys.reject { |key| opts.include?(key) }

      if extra_keys.empty?
        true
      else
        raise InvalidOptionsError.new(extra_keys)
      end
    end
  end
end
