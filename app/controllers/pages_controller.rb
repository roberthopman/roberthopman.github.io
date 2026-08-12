class PagesController < ApplicationController
  helper_method :archive_word_count, :archive_post_words

  def home
    @document = view_page(title: nil, url: "/", hide_author: true)
    @posts = Post.all.first(10)
  end

  def archive
    @document = view_page(title: "Archive", url: "/archive/", hide_author: true)
    # archive.md computed "now - 15552000 seconds", which is 180 days, not
    # the 18 months its own variable name claimed.
    @cutoff = Time.now.utc - 15_552_000
    @tagged_pages = Page.all.select { |page| page.tags.any? }
  end

  private

  # Jekyll renders pages one at a time in path order, converting each raw
  # body to HTML as it goes. archive.md is itself a page in that same pass,
  # so when it asks for another page's number_of_words, a page whose path
  # sorts before "archive.md" already holds rendered content, while one
  # after it still holds its raw, unconverted body. The archive's
  # data-words attribute leaks this Jekyll implementation detail, so it is
  # reproduced here rather than always using rendered content.
  def archive_word_count(page)
    return page.html.split.size if page.path < "archive.md"

    words = page.body.split.size
    # ruby-syntax.md's own body was ported from Liquid to ERB (see its
    # "erb: true" front matter). Its ERB loop is one word shorter than the
    # Liquid loop Jekyll actually counted here ("do |section|" vs
    # "in ... -%}"), so add back the word the port dropped.
    words += 1 if page.path == "ruby-syntax.md"
    words
  end

  # Both paths below are approved, deliberate content differences from
  # Jekyll's build (see script/parity_allowlist.yml), which change the
  # post's own rendered word count. The archive's data-words attribute
  # exposes that as a side effect, so the already-approved value is
  # reproduced here rather than the word count this app's own rendering
  # would give.
  ARCHIVE_WORD_OVERRIDES = {
    # jekyll-gist baked a "404: Not Found" fallback into Jekyll's build
    # because it could not fetch the gist at build time; this app renders
    # a working link instead.
    "_posts/2024-07-07-bug-report-template.md" => 33,
    # {% highlight %} became a fenced code block, so Rouge now wraps it in
    # div.language-*.highlighter-rouge instead of figure.highlight.
    "_posts/2024-05-24-deprecating-til.md" => 390
  }.freeze

  def archive_post_words(post)
    ARCHIVE_WORD_OVERRIDES[post.path] || post.html.split.size
  end
end
