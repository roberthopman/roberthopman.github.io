require "kramdown"

# Jekyll's own "smartify" filter (jekyll-4.4.1's
# lib/jekyll/converters/smartypants.rb) does not run full markdown: it
# points Kramdown at a parser stripped down to typography only. Block-level
# parsing is reduced to "take the rest of the line as one text node"
# (headings, lists, blockquotes never fire), and only four span parsers run
# over that text: smart quotes, HTML entities, typographic symbols (em/en
# dash, ellipsis) and literal HTML passthrough. Emphasis, code spans and
# links are not in that list, so "*args", "`code`" and "[text](url)" come
# out exactly as written instead of becoming <em>/<code>/<a>.
#
# The "SmartyPants" parser this looks up by name is registered in
# config/initializers/kramdown_smartypants_parser.rb, not here: it reopens
# Kramdown's own Parser namespace, which this file's autoload path
# (app/lib, reloaded on every request in development) is the wrong place
# to do more than once per process. This module only knows how to render,
# and is an ordinary autoloadable, reloadable class.
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
