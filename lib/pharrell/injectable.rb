module Pharrell
  module Injectable
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      @@cache = {}

      def injected(name, klass=nil)
        if klass.nil?
          klass_name = name.to_s.split("_").map(&:capitalize).join
          klass = Kernel.const_get(klass_name)
        end

        define_method(name) do
          @@cache[self] ||= {}
          @@cache[self][klass] ||= Pharrell.instance_for(klass)
        end
      end
    end
  end
end
