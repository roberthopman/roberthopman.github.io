require "kramdown"
require "kramdown-parser-gfm"
require "rouge"

module MarkdownRenderer
  # Jekyll's own kramdown defaults, plus the two syntax_highlighter keys that
  # Jekyll::Converters::Markdown::KramdownParser#setup adds at runtime.
  # String keys, because that is what Jekyll passes and what was verified.
  OPTIONS = {
    "auto_ids" => true,
    "toc_levels" => [1, 2, 3, 4, 5, 6],
    "entity_output" => "as_char",
    "smart_quotes" => "lsquo,rsquo,ldquo,rdquo",
    "input" => "GFM",
    "hard_wrap" => false,
    "guess_lang" => true,
    "footnote_nr" => 1,
    "show_warnings" => false,
    "syntax_highlighter" => "rouge",
    "syntax_highlighter_opts" => {
      "default_lang" => "plaintext",
      "guess_lang" => true
    }
  }.freeze

  module_function

  def render(text)
    Kramdown::Document.new(text, OPTIONS).to_html
  end
end
