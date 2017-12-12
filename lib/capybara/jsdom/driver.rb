# frozen_string_literal: true

require "uri"
require "cgi"
require "net/http"
require "capybara"
require "capybara/jsdom/version"
require "capybara/jsdom/node"
require "capybara/jsdom/browser"

module Capybara
  module Jsdom
    # Capybara driver using JSDom lightweight fast DOM implementation.
    class Driver < Capybara::Driver::Base
      attr_writer :session
      attr_accessor :browser

      attr_reader :status_code

      def initialize(app, options = {})
        @app = app
        @options = options.dup
        @browser = options[:browser] || Browser.new(@options)
      end

      def current_url
        browser.current_url
      end

      def visit(url)
        browser.load url
      end

      def refresh
        visit current_url
      end

      def html
        browser.html
      end

      def find_css(query)
        nodes = browser.find_css query
        nodes.map { |n| Node.new(self, n, browser) }
      end

      def go_back
        raise Capybara::NotSupportedByDriverError, "Capybara::Driver::Base#go_back"
      end

      def go_forward
        raise Capybara::NotSupportedByDriverError, "Capybara::Driver::Base#go_forward"
      end

      def execute_script(script, *args)
        raise Capybara::NotSupportedByDriverError, "Capybara::Driver::Base#execute_script"
      end

      def evaluate_script(script, *args)
        raise Capybara::NotSupportedByDriverError, "Capybara::Driver::Base#evaluate_script"
      end

      def evaluate_async_script(script, *args)
        raise Capybara::NotSupportedByDriverError, "Capybara::Driver::Base#evaluate_script_asnyc"
      end

      def save_screenshot(path, options={})
        raise Capybara::NotSupportedByDriverError, "Capybara::Driver::Base#save_screenshot"
      end

      def response_headers
        @response
      end

      # Default methods

      def invalid_element_errors
        []
      end

      def wait?
        true
      end

      def reset!; end

      def needs_server?
        true
      end
    end
  end
end
