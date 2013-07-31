require 'minitest/autorun'
require 'pharrell'

describe "Pharrell" do
  describe ".use_config" do
    it "switches Pharrell to use the specified config" do
      Pharrell.config(:test) do |config|
        config.bind(Time, Time.at(1))
      end

      Pharrell.config(:main) do |config|
        config.bind(Time, Time.at(0))
      end

      Pharrell.use_config(:test)
      assert_equal(Pharrell.instance_for(Time), Time.at(1))

      Pharrell.use_config(:main)
      assert_equal(Pharrell.instance_for(Time), Time.at(0))
    end
  end
end
