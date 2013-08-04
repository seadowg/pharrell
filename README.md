# pharrell

[![Build Status](https://travis-ci.org/seadowg/pharrell.png?branch=master)](https://travis-ci.org/seadowg/pharrell)

![Pharrell](media/pharrell.jpg)

## Installation

Either include in your Gemfile:

```ruby
gem 'pharrell'
```

Or, install for your system:

    > gem install pharrell

## Usage

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
