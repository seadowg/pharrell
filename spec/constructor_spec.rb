require 'spec_helper'
require 'minitest/autorun'
require 'pharrell'

describe "Constructor" do
  before do
    Pharrell.reset!
  end
  
  describe ".contructor" do
    it "allows a class to be lazily created by Pharrell with the defined types" do
      klass = Class.new {
        include Pharrell::Constructor
        
        attr_reader :object, :string
        constructor Object, String
        
        def initialize(object, string)
          @object = object
          @string = string
        end
      }
      
      Pharrell.config(:base) { |c| 
        c.bind(String, "Hello")
        c.bind(Object, 5)
        c.bind(klass, klass)
      }
      
      Pharrell.use_config(:base)

      assert_equal(Pharrell.instance_for(klass).object, 5)
      assert_equal(Pharrell.instance_for(klass).string, "Hello")
    end
  end
end