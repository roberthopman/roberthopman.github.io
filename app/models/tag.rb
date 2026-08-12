# Replaces _plugins/tag_pages.rb: one page per tag found on any post or
# page. Keeps its rule that the first spelling of a tag wins, so "git grep"
# and "Git Grep" would collapse to one page.
class Tag
  attr_reader :name

  def self.all
    @all = nil if Rails.env.development?
    @all ||= begin
      seen = {}
      (Post.all + Page.all).each do |document|
        document.tags.each do |raw|
          name = raw.to_s.strip
          next if name.empty?

          slug = name.parameterize
          next if slug.empty?

          seen[slug] ||= new(name)
        end
      end
      seen.values.sort_by(&:slug)
    end
  end

  def self.find_by_slug(slug)
    all.find { |tag| tag.slug == slug }
  end

  def initialize(name)
    @name = name
  end

  def slug = @slug ||= name.parameterize
  def url = "/tags/#{slug}/"
  def posts = Post.all.select { |post| post.tags.include?(name) }
  def pages = Page.all.select { |page| page.tags.include?(name) }
end
