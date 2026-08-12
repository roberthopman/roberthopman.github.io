require "kramdown"

# Jekyll's own "smartify" filter (jekyll-4.4.1's
# lib/jekyll/converters/smartypants.rb) does not run full markdown: it
# points Kramdown at a parser stripped down to typography only. Block-level
# parsing is reduced to "take the rest of the line as one text node"
# (headings, lists, blockquotes never fire), and only four span parsers run
# over that text: smart quotes, HTML entities, typographic symbols (em/en
# dash, ellipsis) and literal HTML passthrough. Emphasis, code spans and
# links are not in that list, so "*args", "`code`" and "[text](url)" come
# out exactly as written instead of becoming <em>/<code>/<a>. This registers
# the same restricted parser under the same name Kramdown looks up for
# `input: "SmartyPants"`, copied from Jekyll's own file rather than
# reimplemented from a description, so it stays behaviourally identical.
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

module SmartypantsRenderer
  OPTIONS = {
    "entity_output" => "as_char",
    "smart_quotes" => "lsquo,rsquo,ldquo,rdquo",
    "input" => "SmartyPants"
  }.freeze

  module_function

  # No block parsers ever fire under this parser, so there is no
  # paragraph wrapper to strip: the output is the bare converted text.
  def render(text)
    Kramdown::Document.new(text.to_s, OPTIONS).to_html.chomp
  end
end
