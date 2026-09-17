# The archive's word-length filter, one static page per range, so a visit
# shows up in analytics as its own page view.
class WordRangesController < ApplicationController
  # slug => [link label, word count range]
  RANGES = {
    "short" => ["<400", ...400],
    "medium" => ["400-800", 400..800],
    "long" => ["800+", 801..]
  }.freeze

  def show
    @range = params[:range]
    label, words = RANGES.fetch(@range)
    @document = view_page(title: "Archive: #{label} words", url: "/archive/#{@range}/", hide_author: true)
    @posts = Post.all.select { |post| words.cover?(post.word_count) }
    @tagged_pages = Page.all.select { |page| page.tags.any? && words.cover?(page.word_count) }
    render "pages/archive"
  end
end
