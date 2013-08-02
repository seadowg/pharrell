require 'pharrell/config'
require 'pharrell/injectible'

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

  def self.rebuild!
    @@configs[@@config].rebuild!
  end
end
