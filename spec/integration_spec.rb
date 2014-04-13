require 'spec_helper'
require 'minitest/autorun'
require 'pharrell'
require 'pharrell/integration/rspec'

describe "Integration" do
  before do
    Pharrell.reset!
  end

  describe "RSpec" do
    describe ".use_config" do
      it "sets the Pharrell config using before each" do
        fake_rspec = Class.new do
          @@befores = Hash.new([])

          def self.before(scope, &blk)
            @@befores[scope] << blk
          end

          def self.befores
            @@befores
          end
        end

        fake_spec = Class.new(fake_rspec) do
          include Pharrell::Integration::RSpec
          use_config(:test)
        end

        Pharrell.config(:base) do |config|
          config.bind(String, "Base")
        end

        Pharrell.config(:test) do |config|
          config.bind(String, "Test")
        end

        Pharrell.use_config(:base)

        fake_spec.new
        befores = fake_spec.befores

        assert_equal(1, befores[:each].length)
        assert_equal("Base", Pharrell.instance_for(String))

        befores[:each].first.call
        assert_equal("Test", Pharrell.instance_for(String))
      end
    end
  end
end
