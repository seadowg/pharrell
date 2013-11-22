require 'spec_helper'
require 'minitest/autorun'
require 'pharrell'

describe "Pharrell" do
  before do
    Pharrell.reset!
  end
  
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

    it "rebuilds singletons" do
      Pharrell.config(:base) do |config|
        config.bind(Object, Object.new)
      end

      Pharrell.use_config(:base)
      first_instance = Pharrell.instance_for(Object)

      Pharrell.use_config(:base)
      second_instance = Pharrell.instance_for(Object)

      assert(first_instance != second_instance)
    end
    
    it "raises a ConfigNotDefinedError if the config does not exist" do
      begin
        Pharrell.use_config(:main)
        flunk(".use_config did not raise an error!")
      rescue Pharrell::ConfigNotDefinedError => e
        assert_equal("Config has not been defined!", e.message)
      end
    end
  end

  describe ".config" do
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
    
    it "raises a ConfigNotDefinedError if the extended config does not exist" do
      begin
        Pharrell.config(:sub, :extends => :base)
        flunk(".config did not raise an error!")
      rescue Pharrell::ConfigNotDefinedError => e
        assert_equal("Config has not been defined!", e.message)
      end
    end
    
    it "raises an InvalidOptionsError for invalid options" do
      begin
        Pharrell.config(:base, :wrong_opt => "Value", :other_opt => "Value") { |config| }
        flunk(".config did not raise an error!")
      rescue Pharrell::InvalidOptionsError => e
        assert_equal("Invalid options: wrong_opt other_opt", e.message)
      end
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
  
  describe ".instance_for" do
    it "raises a BindingNotFoundError if there is no binding for the instance" do
      Pharrell.config(:main) { |config| }
      Pharrell.use_config(:main)
      
      begin
        Pharrell.instance_for(Object)
        flunk(".instance_for did not raise an error!")
      rescue Pharrell::BindingNotFoundError => e
        assert_equal("Binding could not be found!", e.message)
      end 
    end
  end
end
