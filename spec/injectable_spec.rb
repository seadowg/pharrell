require 'spec_helper'
require 'minitest/autorun'
require 'pharrell'

describe "Injectable" do
  before do
    Pharrell.reset!
  end

  describe ".injected" do
    it "defines a method to retrieve that class from Pharrell" do
      Pharrell.config(:base) { |c| c.bind(String, "Injected") }
      Pharrell.use_config(:base)

      klass = Class.new {
        include Pharrell::Injectable

        injected :string, String
      }

      assert_equal(klass.new.send(:string), "Injected")
    end

    it "caches lazy bindings on the instance" do
      i = 0
      Pharrell.config(:base) { |c| c.bind(Object) { i = i + 1 } }
      Pharrell.use_config(:base)

      klass = Class.new {
        include Pharrell::Injectable

        injected :injected_ob, Object
      }

      object = klass.new
      assert_equal(object.send(:injected_ob), object.send(:injected_ob))
    end
  end
end
