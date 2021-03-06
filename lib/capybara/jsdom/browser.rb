# frozen_string_literal: true

# require "mini_racer"
require "execjs"
require "execjs/fastnode"
require "commonjs"
require "capybara"
require "capybara/jsdom"
require "capybara/jsdom/node"

# ExecJS.runtime = ExecJS::Runtimes::Node

# ExecJS.runtime =
#   ExecJS::ExternalRuntime.new(
#     name: "Node.js (V8) Raw!",
#     # command: ["nodejs NODE_PATH='#{File.join(root, 'node_modules')}'", "node NODE_PATH='#{File.join(root, 'node_modules')}'"],
#     command: ["nodejs", "node"],
#     runner_path: File.join(root, "node_runner.js"),
#     encoding: "UTF-8"
#   )

# ExecJS.runtime = ExecJS::Runtimes::FastNode

root = Gem::Specification.find_by_name("capybara-jsdom").gem_dir
ExecJS.runtime =
  ExecJS::FastNode::ExternalPipedRuntime.new(
    name:        "Node.js (V8) fast",
    command:     %w[nodejs node],
    # command:     ["nodejs --expose-gc", "node"],
    # command:     ["nodejs --expose-gc", "node --expose-gc"],
    # command:     "node --expose-gc",
    runner_path: File.join(root, "node_piped_runner.js"),
    encoding:    "UTF-8"
  )

module Capybara
  module Jsdom
    # Fake browser using JSDom
    class Browser
      attr_accessor :browser, :js
      attr_reader :current_url

      def initialize(options = {})
        @options = options.dup
      end

      def js
        $js
      end

      # Each `load` creates a new context that is then reused for every
      # `command`. Thus with a lot of tests loading a lot of pages the
      # Node server keeps a lot of contexts open and runs out of memory.
      # We must destroy previous contexts before each load.
      # This may mean we can't parallelize.
      # ExecjsFastnode does have a finalizer for this purpose but it doesn't
      # seem to work.
      # https://github.com/jhawthorn/execjs-fastnode/blob/be8033387d61c58244d75cf4c1ee1b09b7151a70/lib/execjs/fastnode/external_piped_runtime.rb#L119
      def destroy_previous_contexts
        return unless $js

        runtime = $js.instance_variable_get :@runtime
        uuid = $js.instance_variable_get :@uuid
        runtime.vm.delete_context(uuid)
      end

      def command(command)
        js.eval command
      end

      def quote(query)
        q = query =~ /'/ ? '"' : "'"
        "#{q}#{query}#{q}"
      end

      def html
        command %(document.head.outerHTML + document.body.outerHTML)
      end

      # Main entry point
      def load(path)
        destroy_previous_contexts

        @current_url = path
        uri = URI(@current_url)
        req = Net::HTTP::Get.new(uri)
        @response = Net::HTTP.start(
          uri.hostname, uri.port, read_timeout: 120
        ) { |h| h.request(req) }
        @html = @response.body
        @status_code = @response.code
        @cookies = @response.get_fields("set-cookie")
        html = @html.gsub("\n", " ").squeeze(" ").scrub("").force_encoding('UTF-8').gsub("'") { "\\'" }
          # dom = new JSDOM('<!DOCTYPE html><p>Hello world</p><p>foo</p>');
        $js = ExecJS.compile(<<~JAVASCRIPT)
          const jsdom = require("#{Capybara::Jsdom.root}/node_modules/jsdom");
          #{File.read("#{Capybara::Jsdom.root}/lib/capybara/jsdom/jsdom.js")}
          #{%(cookieJar.setCookie("#{@cookies.first}", "#{@current_url}", { loose: true }, function() {});) if @cookies}
          dom = new JSDOM(
            '#{html}',
            {
              url: "#{@current_url}",
              resources: "usable",
              runScripts: "dangerously",
              cookieJar: cookieJar
            }
          );
          window = dom.window;
          document = dom.window.document;
          console = dom.window.console;

          //JSDOM.fromURL(
          //  "#{@current_url}",
          //  {
          //    resources: "usable",
          //    runScripts: "dangerously",
          //    cookieJar: cookieJar
          //  }
          //).then(dom => {
          //  jsdomDone(dom);
          //});
        JAVASCRIPT

        # jsdom_waiting = true;
        # while jsdom_waiting
        #   jsdom_waiting = command %(jsdomWaiting)
        # end
      end

      def find_css(query)
        command(<<~JAVASCRIPT)
          [].map.call(document.querySelectorAll(#{quote(query)}), function(n) {
            return cacheNode(n);
          })
        JAVASCRIPT
      end

      def find_xpath(query)
        command(<<~JAVASCRIPT)
          (function(xpathResult) {
            var cachedNodes = [];
            for (var i = 0; i < xpathResult.snapshotLength; i++) {
              cachedNodes = cachedNodes.concat(cacheNode(xpathResult.snapshotItem(i)));
            };
            return cachedNodes;
          })(document.evaluate(#{quote(query)}, document.documentElement, null, window.XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null))
        JAVASCRIPT
      end
    end
  end
end
