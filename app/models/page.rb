class Page < Document
  EXCLUDED = %w[AGENTS.md CLAUDE.md README.md].freeze

  def self.glob = "{*.md,404.html}"

  def self.load_all
    super.reject { |page| EXCLUDED.include?(page.path) }
  end

  def kind = :page

  def slug
    @slug ||= File.basename(path, File.extname(path))
  end

  def url
    return permalink if permalink
    return "/" if slug == "index"

    # Every page URL ends in a slash, the convention the old Jekyll permalink
    # setting used. That is why ai.md is /ai/ and not /ai.html.
    "/#{slug}/"
  end

  def date = front_matter["date"]&.to_time
end
