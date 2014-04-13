module Pharrell
  module Integration
    module RSpec
      def configure(config_name, rspec_config)
        config.include(Pharrell::Injectable)
        config.include(Pharrell::Integration::RSpec)

        config.before(:each) do
          Pharrell.use_config(config_name)
        end
      end

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
