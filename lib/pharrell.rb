require 'pharrell/config'
require 'pharrell/injectible'

module Pharrell
  @@configs = {}
  @@config = nil

  def self.config(name, &blk)
    @@configs[name] = Config.new
    blk.call(@@configs[name])
  end

  def self.use_config(name)
    @@config = name
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
