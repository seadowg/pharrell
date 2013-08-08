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

    it "allows extensions of a previous config" do
      Pharrell.config(:main) do |c|
        c.bind(Object, "Object")
        c.bind(String, "Hello")
      end

      Pharrell.config(:test, :extends => :main) do |c|
        c.bind(String, "Hello, Test")
      end

      Pharrell.use_config(:test)
      assert_equal(Pharrell.instance_for(Object), "Object")
      assert_equal(Pharrell.instance_for(String), "Hello, Test")
    end
  end

  describe ".rebuild!" do
    it "forces all bound values to be rebuilt" do
      Pharrell.config(:main) do |config|
        config.bind(Object, Object.new)
      end

      Pharrell.use_config(:main)

      original = Pharrell.instance_for(Object)
      Pharrell.rebuild!
      assert(Pharrell.instance_for(Object) != original)
    end
  end
end
