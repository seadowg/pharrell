require 'pharrell/config'
require 'pharrell/injectible'

module Pharrell
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

  private

  def self.current_config
    @@configs[@@config]
  end
end
