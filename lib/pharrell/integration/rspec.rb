module Pharrell
  module Integration
    module RSpec
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def use_config(config)
          before(:each) do
            Pharrell.use_config(config)
          end
        end
      end
    end
  end
end
