# frozen_string_literal: true

module Capybara
  module Jsdom
    # Node represents a page element
    class Node < Capybara::Driver::Node
      attr_accessor :browser

      def initialize(driver, native, browser)
        super(driver, native)
        @browser = browser
      end

      def find_css(query)
        nodes = command(<<~JAVASCRIPT)
          [].map.call(#{node}.querySelectorAll('#{query}'), function(n) {
            return cacheNode(n);
          });
        JAVASCRIPT
        nodes.map { |n| Node.new(driver, n, browser) }
      end

      def all_text
        text = node_command %(textContent)
        Capybara::Helpers.normalize_whitespace(text)
      end

      def visible_text
        # FIXME not actually checking visibility yet
        text = node_command %(textContent)
        Capybara::Helpers.normalize_whitespace(text)
      end

      def [](name)
        # TODO What is this method supposed to do? Attribute or property?
        # node_command %(attributes["#{name}"].value)
        node_command name
      end

      def value
        node_command %(value)
      end

      # @param value String or Array. Array is only allowed if node has 'multiple' attribute
      # @param options [Hash{}] Driver specific options for how to set a value on a node
      def set(value, options={})
        raise NotImplementedError
      end

      def select_option
        raise NotImplementedError
      end

      def unselect_option
        raise NotImplementedError
      end

      def click
        node_command %(click())
      end

      def right_click
        raise NotImplementedError
      end

      def double_click
        raise NotImplementedError
      end

      def send_keys(*args)
        raise NotImplementedError
      end

      def hover
        raise NotImplementedError
      end

      def drag_to(element)
        raise NotImplementedError
      end

      def tag_name
        node_command(%(nodeName)).downcase
      end

      def inner_html
        node_command %(innerHTML)
      end

      def visible?
        # FIXME check input type=hidden, css visibility, display, opacity etc
        !node_command %(getAttribute("hidden"))
      end

      def checked?
        node_command %(checked)
      end

      def selected?
        node_command %(selected)
      end

      def disabled?
        node_command %(disabled)
      end

      def path
        raise NotSupportedByDriverError, "Capybara::Driver::Node#path"
      end

      def trigger(event)
        raise NotSupportedByDriverError, "Capybara::Driver::Node#trigger"
      end

      def ==(other)
        raise NotSupportedByDriverError, "Capybara::Driver::Node#=="
      end

      private

      def node
        "getNode(#{native})"
      end

      def node_command(command)
        command "#{node}.#{command}"
      end

      def command(command)
        browser.command command
      end
    end
  end
end
