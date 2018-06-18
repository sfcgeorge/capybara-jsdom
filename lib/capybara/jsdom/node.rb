# frozen_string_literal: true

module Capybara
  module Jsdom
    # Node represents a page element
    class Node < Capybara::Driver::Node
      attr_accessor :browser

      def initialize(driver, native, browser)
        super(driver, "getNode(#{native})")
        @browser = browser
      end

      def find_css(query)
        nodes = command(<<~JAVASCRIPT)
          [].map.call(#{native}.querySelectorAll('#{query}'), function(n) {
            return cacheNode(n);
          })
        JAVASCRIPT
        nodes.map { |n| Node.new(driver, n, browser) }
      end

      def find_xpath(query)
        nodes = command(<<~JAVASCRIPT)
          (function(xpathResult) {
            var cachedNodes = [];
            for (var i = 0; i < xpathResult.snapshotLength; i++) {
              cachedNodes = cachedNodes.concat(cacheNode(xpathResult.snapshotItem(i)));
            };
            return cachedNodes;
          })(document.evaluate(#{quote(query)}, #{native}, null, window.XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null))
        JAVASCRIPT
        nodes.map { |n| Node.new(driver, n, browser) }
      end

      def all_text
        text = native_command %(textContent)
        # Capybara::Helpers.normalize_whitespace(text) # Deprecated
        text.gsub(/[\u200b\u200e\u200f]/, '')
            .gsub(/[\ \n\f\t\v\u2028\u2029]+/, ' ')
            .gsub(/\A[[:space:]&&[^\u00a0]]+/, "")
            .gsub(/[[:space:]&&[^\u00a0]]+\z/, "")
            .tr("\u00a0", ' ')
      end

      def visible_text
        # FIXME not actually checking visibility yet
        all_text
      end

      def [](name)
        # TODO What is this method supposed to do? Attribute or property?
        # native_command %(attributes["#{name}"].value)
        native_command name
      end

      def value
        native_command %(value)
      end

      # @param value String or Array. Array is only allowed if node has 'multiple' attribute
      # @param options [Hash{}] Driver specific options for how to set a value on a node
      def set(value, options={})
        if value.is_a?(Array)
          raise NotImplementedError
        elsif self[:type] == "checkbox"
          native_command %(checked = #{value})
        else
          native_command %(value = "#{value.gsub('"', '\"')}")
        end
      end

      def select_option
        raise NotImplementedError
      end

      def unselect_option
        raise NotImplementedError
      end

      # TODO: handle keys (held down modifiers?) and options
      def click(keys = [], **options)
        native_command %(click())
      end

      # NOTE: selenium seems to do "context click", trigger that instead?
      # https://github.com/teamcapybara/capybara/blob/faacc7c86510ad0a6e252de518f03fa2867d97e0/lib/capybara/selenium/node.rb#L101
      def right_click(keys = [], **options)
        raise NotImplementedError
      end

      # TODO: add a delay?
      def double_click(keys = [], **options)
        native_command %(click())
        native_command %(click())
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
        native_command(%(nodeName)).downcase
      end

      def inner_html
        native_command %(innerHTML)
      end

      def visible?
        # FIXME check input type=hidden, css visibility, display, opacity etc
        !native_command %(getAttribute("hidden"))
      end

      def checked?
        native_command %(checked)
      end

      def selected?
        native_command %(selected)
      end

      def disabled?
        native_command %(disabled)
      end

      def path
        command %(getPathTo(#{native}))
      end

      def trigger(event)
        native_command %(#{event}())
      end

      def ==(other)
        command %(#{native} === #{other.native})
      end

      private

      def quote(query)
        browser.quote(query)
      end

      def native_command(command)
        command "#{native}.#{command}"
      end

      def command(command)
        browser.command command
      end
    end
  end
end
