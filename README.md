# Capybara JSDOM Driver

This is an experimental Capybara driver using JSDOM. That means it can run JavaScript and handle things like click events and AJAX (unlike the Rack driver). It doesn't do any layout or rendering (unlike the Selenium driver), but this makes it faster. Capybara JSDOM is in the order of 10x faster than Selenium, while being about 10x slower than Rack. So it's in the middle for performance and features. 

You could use Capybara JSDOM for thoroughly testing individual frontend components as fast as possible when they require JavaScript. Then you could use Selenium for a few full page acceptance tests.

Experimental means it's not finished or well tested. It implements just enough of the Capybara API to do a few simple tests, but the rest of the API shouldn't be hard to fill in. I've also only got it to work on 1 test so far, but it's proven the concept works.


## Installation

Add it to your Gemfile:

```ruby
gem 'capybara-jsdom'
```

Then require and enable it in your spec helper:

```ruby
# spec/spec_helper.rb
require "capybara/jsdom"

Capybara.default_driver = :jsdom
```

Done!


## Usage

### Potential issues:

* jQuery AJAX may not work. Apparently it can be made to work with JSDOM but I failed. Use plain XMLHttpRequest or a lighter AJAX lib.
* Errors in \<script\> tags may be hard to debug. Try commenting stuff out and adding in `console.log()` lines until you see what's working / isn't.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sfcgeorge/capybara-jsdom. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Capybara::Jsdom project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/sfcgeorge/capybara-jsdom/blob/master/CODE_OF_CONDUCT.md).
