require 'minitest/autorun'
require 'pharrell'

describe "Injectible" do
  describe ".inject" do
    it "defines a method to retrieve that class from Pharrell" do
      Pharrell.config(:base) { |c| c.bind(String, "Injected") }
      Pharrell.use_config(:base)

      klass = Class.new {
        include Pharrell::Injectible

        inject :string, String
      }

      assert_equal(klass.new.send(:string), "Injected")
    end
  end
end
