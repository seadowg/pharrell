module Pharrell
  module Integration
    module RSpec
      def self.configure(config_name, rspec_config)
        rspec_config.include(Pharrell::Injectable)
        rspec_config.include(Pharrell::Integration::RSpec)

        rspec_config.before(:each) do
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
