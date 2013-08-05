require 'minitest/autorun'
require 'pharrell'

describe "Pharrell::Config" do
  describe "#instance_for" do
    it "returns an instance bound to a class" do
      config = Pharrell::Config.new(Proc.new { |c|
        c.bind(Time, Time.at(0))
      })

      assert_equal(config.instance_for(Time), Time.at(0))
    end

    it "returns an instance created from a class bound to a class" do
      my_class = Class.new
      config = Pharrell::Config.new(Proc.new { |c|
        c.bind(String, my_class)
      })

      assert_equal(config.instance_for(String).class, my_class)
    end

    it "allows a lazy instance to be passed as a block" do
      config = Pharrell::Config.new(Proc.new { |c|
        c.bind(Object) { Object.new }
      })

      assert(config.instance_for(Object) != config.instance_for(Object))
    end
  end
end
