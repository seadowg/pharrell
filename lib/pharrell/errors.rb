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
end
