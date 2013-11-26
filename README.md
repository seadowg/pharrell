# pharrell

[![Build Status](https://travis-ci.org/seadowg/pharrell.png?branch=master)](https://travis-ci.org/seadowg/pharrell)
[![Coverage Status](https://coveralls.io/repos/seadowg/pharrell/badge.png?branch=master)](https://coveralls.io/r/seadowg/pharrell?branch=master)

![Pharrell](media/pharrell.jpg)

## Installation

Either include in your Gemfile:

```ruby
gem 'pharrell'
```

Or, install for your system:

    > gem install pharrell

## Usage

### Basics

You can inject dependencies into classes like so:

```ruby
class CurrentTime
  include Pharrell::Injectible

  inject :current_time, Time

  def to_s
    hour = current_time.hour % 12
    "The time is #{hour == 0 ? 12 : hour} o'clock"
  end
end
```

The values injected are dependent on the current conifguration:

```ruby
Pharrell.config(:base) do |config|
  config.bind(Time) { Time.now }
end

Pharrell.use_config(:base)
```

You can use configurations to change the injected values in different
scenarios. For instance, we can use Pharrell to help us test `CurrentTime` class
defined above:

```ruby
require 'minitest/autorun'

Pharrell.config(:test) do |config|
  config.bind(Time, Time.at(0))
end

describe "CurrentTime" do
  before do
    Pharrell.use_config(:test)
  end

  it "displays the time of day" do
    assert_equal(CurrentTime.new.to_s, "The time is 12 o'clock")
  end
end
```

### Bindings

When building configurations in pharrell you can bind instances to
produce to classes in three different ways:

```ruby
Pharrell.config(:example) do |config|
  config.bind(Object) { Object.new } # Evaluate and return for each injected Object
  config.bind(Enumerable, Array) # Return a new instance of Array for each injected Enumerable
  config.bind(String, "Hello") # Every injected String will be the same instance of "Hello"
end
```

The last option (every String is "Hello") allows you to
provides singletons using Pharrell. It's important to note that calling
`.use_config` will cause the specified configuration to rerun its
definition block and rebuild all singletons. This is useful in testing
as you can assert on an object shared between test and real code without
worrying about resetting or rebuilding it to avoid test pollution.

### Extending Configurations

You can also extend configurations. This allows you to use all the
bindings from the original configuration and override bindings you want
to change. For instance:

```ruby
Pharrell.use_config(:base) do |config|
  config.bind(String, "This string")
  config.bind(Hash, { :key => "value" })
end

Pharrell.use_config(:more, :extends => :base) do |config|
  config.bind(String, "This string instead")
end
```
### Using with Rails

Pharrell is really easy to set up with Rails. Here's an example similar to the `Time` example we used before:

**config/application.rb**

```ruby
class Application < Rails::Application
  config.to_prepare do
    Pharrell.config do |config|
      config.bind(Time, Time)
    end
    
    Pharrell.use_config(:base)
  end
end
```

Pharrell should be configured in the Rails Application's `#to_prepare` method as this runs at startup
in production and before each request in development. You can then attach your test configuration for Pharrell to
whatever test framework you use (exactly as in the first example).
