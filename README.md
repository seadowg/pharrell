# Pharrell

![Pharrell](media/pharrell.jpg)

## Installation

Either include in your Gemfile:

```ruby
    gem 'pharrell'
```

Or, install for your system:

    > gem install pharrell

## Usage

```ruby
    Pharrell.config(:base) do |config|
      config.bind(Time) { Time.now }
    end

    Pharrell.config(:test) do |config|
      config.bind(Time, Time.at(0))
    end

    Pharrell.use_config(:base)

    class CurrentTime
      include Pharrell::Injectible

      inject :current_time

      def to_s
        "The time is #{current_time}"
      end
    end
```
