require "capybara/jsdom/version"
require "capybara"
require "capybara/jsdom/driver"

module Capybara
  module Jsdom
    def self.root
      Gem::Specification.find_by_name("capybara-jsdom").gem_dir
    end
  end
end

Capybara.register_driver :jsdom do |app|
  Capybara::Jsdom::Driver.new(app, {})
end
