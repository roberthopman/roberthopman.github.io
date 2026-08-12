require "front_matter_parser"

class Document
  # YAML front matter carries bare dates like 2026-08-09, which the safe loader
  # rejects unless Date is allowed.
  LOADER = FrontMatterParser::Loader::Yaml.new(allowlist_classes: [Date, Time])

  attr_reader :path, :front_matter, :body

  class << self
    def all
      # Rails reloads app/, but it does not watch _posts/. Re-globbing per
      # request in development is what makes "save the file, refresh" work.
      Rails.env.development? ? load_all : (@all ||= load_all)
    end

    def find_by_slug(slug)
      all.find { |document| document.slug == slug }
    end

    # Slugs are not unique and are not the URL: _posts/2024-05-04-tools.md
    # has slug "tools" but url "/tools-keyboard-shortcuts/", while tools.md
    # also has slug "tools" and owns "/tools/". Routing must resolve on the
    # url, not the slug, or one of the two silently shadows the other.
    def find_by_url(path)
      candidate = path.end_with?("/") ? path : "#{path}/"
      (Post.all + Page.all).find { |document| document.url == candidate || document.url == path }
    end

    def load_all
      Dir.glob(glob, base: Rails.root).sort.map { |relative| new(relative) }
    end

    def glob
      raise NotImplementedError
    end
  end

  def initialize(path)
    @path = path
    # Jekyll's front matter is always the plain "---\n...\n---" block, for
    # every file type. front_matter_parser instead infers syntax from the
    # extension, and for .html it expects HTML-comment-wrapped delimiters
    # (<!-- --- ... --- -->). 404.html uses the plain block like every other
    # page, so the syntax must be forced or its front matter parses empty.
    parsed = FrontMatterParser::Parser.parse_file(Rails.root.join(path), syntax_parser: :md, loader: LOADER)
    @front_matter = parsed.front_matter || {}
    @body = parsed.content
  end

  def [](key) = front_matter[key]
  def title = front_matter["title"]
  def page_title = front_matter["page_title"]
  # A String for a single author, or an Array for several. Falls back to
  # Site.author_name in the view when a document declares none of its own.
  def author = front_matter["author"]
  def tags = Array(front_matter["tags"])
  def erb? = front_matter["erb"] == true
  def permalink = front_matter["permalink"]
  def sidebar = front_matter["sidebar"]
  def hide_author? = front_matter["hide_author"] == true
  def hide_last_updated? = front_matter["hide_last_updated"] == true
  def comments? = front_matter["comments"] != false

  def image
    # config/site.yml sets a default image for both posts and pages.
    front_matter["image"] || Site.image
  end

  def description = front_matter["description"]

  # ai.md stores "15-02-2026", a String in day-month-year order, not a YAML
  # date. Jekyll parses it through its date filter and emits
  # 2026-02-15T00:00:00+01:00, so parsing is required here too.
  def last_modified_at
    raw = front_matter["last_modified_at"]
    return date if raw.nil?
    return raw.to_time if raw.respond_to?(:to_time)

    Date.parse(raw.to_s).to_time
  end

  # archive.md prints the front matter value verbatim, not the parsed one.
  def last_modified_raw
    front_matter["last_modified_at"]
  end

  def html
    @html ||= MarkdownRenderer.render(source_text)
  end

  # The raw excerpt string, before rendering. Jekyll takes the first block
  # delimited by a blank line when front matter declares none, then (see
  # extract_excerpt below) appends any markdown link reference definition
  # from the rest of the body that the excerpt itself uses.
  def excerpt_source
    front_matter["excerpt"].presence || extract_excerpt(body.strip)
  end

  def excerpt_html
    @excerpt_html ||= MarkdownRenderer.render(excerpt_source.to_s)
  end

  private

  # Mirrors Jekyll::Excerpt#extract_excerpt (jekyll-4.4.1, lib/jekyll/excerpt.rb).
  # A reference-style link like "[text][ref]" only resolves when its
  # "[ref]: url" definition line travels with the excerpt; without it the
  # excerpt renders the literal "[text][ref]" wherever it is reused (tag
  # pages, feed.xml). The excerpt separator is "\n\n" (this site never sets
  # a custom excerpt_separator), so the head is the same first block
  # split("\n\n").first used to take; partition also keeps the remainder
  # intact as one string so it can be scanned for definitions.
  MKDWN_LINK_REF_REGEX = /^ {0,3}(?:(\[[^\]]+\])(:.+))$/

  def extract_excerpt(content)
    head, _, tail = content.partition("\n\n")
    return head if tail.empty?

    definitions = tail.scan(MKDWN_LINK_REF_REGEX).select { |segments| head.include?(segments[0]) }.map(&:join)
    return head if definitions.empty?

    "#{head}\n\n#{definitions.join("\n")}"
  end

  def source_text
    return body unless erb?

    # Opt-in only. One post teaches ERB and contains literal <% in its prose,
    # so a global ERB pass would execute the example.
    ERB.new(body, trim_mode: "-").result(binding)
  end

  # Available to bodies rendered through ERB.
  def data(name) = Site.data(name)
end
