require 'spec_helper'
require 'minitest/autorun'
require 'pharrell'

describe "Injectable" do
  before do
    Pharrell.reset!
  end
  
  describe ".inject" do
    it "defines a method to retrieve that class from Pharrell" do
      Pharrell.config(:base) { |c| c.bind(String, "Injected") }
      Pharrell.use_config(:base)

      klass = Class.new {
        include Pharrell::Injectable

        inject :string, String
      }

      assert_equal(klass.new.send(:string), "Injected")
    end
  end
end
