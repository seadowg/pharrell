module Pharrell
  module Injectible
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def inject(name, klass)
        define_method(name) do
          Pharrell.instance_for(klass)
        end
      end
    end
  end
end
