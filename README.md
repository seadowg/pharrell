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
class BlackBox
  include Pharrell::Injectable

  injected :current_time, Time

  def to_s
    hour = current_time.hour % 12
    "The time is #{hour == 0 ? 12 : hour} o'clock"
  end
end
```

The values injected are dependent on the current configuration:

```ruby
Pharrell.config(:base) do |config|
  config.bind(Time) { Time.now }
end

class Base < Pharrell::Configuration
  provider :time, Time

  def time
    Time.now
  end
end

Pharrell.use_config(Base)
```

You can use configurations to change the injected values in different
scenarios. For instance, we can use Pharrell to help us test the `BlackBox` class
defined above:

```ruby
require 'minitest/autorun'

Pharrell.config(:test) do |config|
  config.bind(Time, Time.at(0))
end

class Test < Pharrell::Configuration
  provider :time, Time

  def time
    Time.at(0)
  end
end

describe BlackBox do
  before do
    Pharrell.use_config(Test)
  end

  it "displays the time of day" do
    assert_equal(BlackBox.new.to_s, "The time is 12 o'clock")
  end
end
```

### Constructor Injection

When you're working with objects that have to be a black box
(like a Rails controller for instance) you will need to inject dependencies artificially
like in the basic example before. It's a lot nicer to be able to design your
other objects so their dependencies are injected directly into their constructor i.e.
they do not cheat. This will make your components easier to reason about and easier to test.

We can break the previous example into its object to achieve this:

```ruby
class PrettyTime
  def initialize(current_time)
    @current_time = current_time
  end

  def to_s
    hour = @current_time.hour % 12
    "The time is #{hour == 0 ? 12 : hour} o'clock"
  end
end
```

This is great but what if we want to construct a `PrettyTime` instance in the
`BlackBox` class without having to inject `Time`?

For this we can use constructor injection:

```ruby
class PrettyTime
  include Pharrell::Constructor

  constructor Time

  def initialize(current_time)
    @current_time = current_time
  end

  def to_s
    hour = @current_time.hour % 12
    "The time is #{hour == 0 ? 12 : hour} o'clock"
  end
end
```

We can then inject `PrettyTime` straight into `BlackBox`:

```ruby
class BlackBox
  include Pharrell::Injectable

  injected :pretty_time, PrettyTime

  def to_s
    pretty_time.to_s
  end
end
```

Our binding would then look like this:

```ruby
class Base < Pharrell::Configuration
  provider :time, Time

  def time
    Time.now
  end
end
```

Because we marked `PrettyTime` as having constructor injection
pharrell will build `PrettyTime` with the bound instance of `Time` when it is injected.

This approach may seem more complex but it allows you to move most of your application's logic
into more responsible components and should free you from using
magic dependency injection (DI frameworks, stubbing factories etc) anywhere but at the top level.

### Using with Rails

Pharrell is really easy to set up with Rails. Here's an example similar to the `Time` example we used before:

**config/application.rb**

```ruby
class Application < Rails::Application
  class Base < Pharrell::Configuration
    def time
      Time.now
    end
  end

  config.to_prepare do
    Pharrell.use_config(Base)
  end
end
```

**spec/spec_helper.rb**

```ruby
class Test < Pharrell::Configuration
  def time
    @fake_time ||= FakeTime.new
  end
end

RSpec.configure do |config|
  config.include Pharrell::Injectable

  config.before(:each) do
    Pharrell.use_config(Test)
  end
end
```

Pharrell should be configured in the Rails Application's `#to_prepare` method as this runs at startup
in production and before each request in development.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
