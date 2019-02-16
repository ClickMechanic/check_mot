[![CircleCI](https://circleci.com/gh/ClickMechanic/check_mot.svg?style=svg)](https://circleci.com/gh/ClickMechanic/check_mot)

# Check MOT

Ruby implementation of UK Government [MOT History API](https://www.check-mot.service.gov.uk/mot-history-api). 

From the official API documentation:
> The MOT history API gives authorised third-party organisations a way to access MOT test history information for vehicles.
>  
>  The information includes:
>  
>  - MOT test date
>  - MOT expiry date
>  - test result
>  - mileage reading
>  - MOT test number
>  - reasons for failure and advisory notices
>  - first MOT due date for new vehicles
>  - vehicle ID
>  - vehicle registration date
>  - vehicle manufacturing date
>  - cylinder capacity of the engine
>
> To access API you will need an API key that uniquely identifies the source of the request. DVSA will give you an API key if it approves your application.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'check_mot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install check_mot

## Usage

Require the dependency in your project:

```ruby
require 'check_mot'
```

Configure your API key:
```ruby
CheckMot.configure do |config|
  config.api_key = <your_api_key>
end
```

The gem uses Faraday under the hood.  To optionally configure the HTTP adapter for Faraday, add the following to your `CheckMot` config:
```ruby
config.http_adapter = <your_http_adapter>
```

To check a vehicle's MOT history using the registration number:
```ruby
check_mot = CheckMot::Client.new
result = check_mot.by_vehicle_registration('AB01CDF')

result.registration # => "AB01CFD"
result.mot_tests.first.completed_date # => 2019-02-16 21:40:00
# etc
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ClickMechanic/check_mot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CheckMot project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/check_mot/blob/master/CODE_OF_CONDUCT.md).
