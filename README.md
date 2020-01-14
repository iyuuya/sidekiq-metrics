# Sidekiq::Metrics
[![Gem Version](https://badge.fury.io/rb/sidekiq-metrics.svg)](https://badge.fury.io/rb/sidekiq-metrics)

Metrics about your workers of Sidekiq.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq-metrics'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sidekiq-metrics

## Configuration

### Basic
```ruby
Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Metrics::Middleware
  end
end
```

### Adapter
```ruby
Sidekiq::Metrics.configure do |config|
  config.adapter = Sidekiq::Metrics::Adapter::Logger.new(Sidekiq.logger)
  # config.adapter = Sidekiq::Metrics::Adapter::Logger.new(Rails.logger)
end
```

### Exclude worker
```ruby
Sidekiq::Metrics.configure do |config|
  # Add worker name to excludes if you want to exclude
  config.excludes << 'VeryLightWorker' # Please add `String`.
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/iyuuya/sidekiq-metrics. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Sidekiq::Metrics project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/iyuuya/sidekiq-metrics/blob/master/CODE_OF_CONDUCT.md).

## License

MIT License
