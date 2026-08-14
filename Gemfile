source "https://rubygems.org"
ruby file: ".ruby-version"

gem "rails", "~> 8.1"
gem "parklife"
gem "parklife-rails"

gem "front_matter_parser"
gem "kramdown"
gem "kramdown-parser-gfm"
# Jekyll's own gemspec caps rouge at "< 5.0" (its Python lexer, among
# others, reclassifies tokens in 5.x: builtins move from Name.Function to
# Name.Builtin, "print" moves from a function call to a keyword). Left
# unpinned here, Bundler resolves the newest 5.x and every fenced Python
# code block renders with different <span> classes than Jekyll's own build.
gem "rouge", ">= 3.0", "< 5.0"
gem "puma"

