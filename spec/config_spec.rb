require 'minitest/autorun'
require 'pharrell'

describe "Pharrell::Config" do
  describe "#instance_for" do
    it "returns an instance bound to a class" do
      config = Pharrell::Config.new
      config.bind(Time, Time.at(0))
      assert_equal(config.instance_for(Time), Time.at(0))
    end
  end
end
