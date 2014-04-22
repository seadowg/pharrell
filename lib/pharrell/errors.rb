module Pharrell
  class BindingNotFoundError < Exception
    def initialize(klass)
      @klass = klass
    end

    def message
      "Binding for #{@klass} could not be found!"
    end
  end

  class ConfigNotDefinedError < Exception
    def initialize(config)
      @config = config
    end

    def message
      "Config '#{@config}' has not been defined!"
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
end
