# Registers Kramdown::Parser::SmartyPants, a THIRD-PARTY namespace this app
# does not own. `define_parser` mutates Kramdown::Parser global state
# (Kramdown::Parser.const_set plus an entry in its @@parsers registry) as a
# side effect, so it must run exactly once per process.
#
# This lives in config/initializers, not app/lib, because Rails' reloadable
# autoload path (app/**) is exactly the wrong place for that: Zeitwerk
# unloads and re-executes a changed autoload file on every request in
# development, but a reopened third-party class is not Zeitwerk-managed and
# is never unloaded, so a second `define_parser` call would run against a
# parser that already exists and raise. An initializer runs once at boot and
# is never touched by the reloader, which is what "runs exactly once" needs.
#
# See app/lib/smartypants_renderer.rb for the class this parser exists to
# support, and for why the restricted parser itself (block/span parser list)
# has to match Jekyll's SmartyPants-only Kramdown parser byte for byte.
require "kramdown"

module Kramdown
  module Parser
    class SmartyPants < Kramdown::Parser::Kramdown
      def initialize(source, options)
        super
        @block_parsers = [:block_html, :content]
        @span_parsers = [:smart_quotes, :html_entity, :typographic_syms, :span_html]
      end

      def parse_content
        add_text @src.scan(%r!\A.*\n!)
      end
      define_parser(:content, %r!\A!)
    end
  end
end
