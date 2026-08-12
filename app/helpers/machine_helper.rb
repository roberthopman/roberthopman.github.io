# Ports feed.xml (jekyll-feed), sitemap.xml and llms.txt byte-for-byte.
#
# All three were Liquid templates. Liquid emits tag-adjacent whitespace
# literally (no trimming) unless a template opts into "-" trim markers, so
# every loop below is built as a plain Ruby string append rather than an ERB
# <% %> loop: Rails' Erubi handler trims the newline around a bare code-only
# <% %> line automatically, which would silently swallow the blank lines
# Liquid's sitemap.xml.liquid produced and break the byte comparison this
# file exists to pass. jekyll-feed additionally minifies its own template
# (strips whitespace that follows ">" or "}") before Liquid ever sees it,
# which is why feed_xml below reads as one packed line: see
# jekyll-feed-0.17.0/lib/jekyll-feed/generator.rb MINIFY_REGEX.
module MachineHelper
  XML_ESCAPES = { "&" => "&amp;", "<" => "&lt;", ">" => "&gt;", '"' => "&quot;", "'" => "&apos;" }.freeze

  # Matches Jekyll's xml_escape filter (REXML's String#encode(xml: :attr)).
  # Rails' own h()/CGI.escapeHTML escapes an apostrophe as "&#39;" instead
  # of "&apos;", which would produce a byte mismatch, so this is hand-rolled
  # rather than reusing Rails' auto-escaping.
  def xml_escape(value)
    value.to_s.gsub(/[&<>"']/, XML_ESCAPES)
  end

  # site.time in Jekyll is captured once and reused for every page in a
  # build. feed.xml and sitemap.xml are two separate requests within one
  # Parklife build (the same Ruby process, so a module-level memo is
  # enough to keep them from drifting a second apart), so this is memoized
  # at the module level rather than recomputed per call. Rendered the way
  # Jekyll's date_to_xmlschema filter would: always a numeric "+00:00"
  # offset. Time#iso8601 differs by object type here (a plain UTC Time
  # renders "Z" under ActiveSupport, while the Time objects elsewhere in
  # this file, built through TZ=UTC's local offset, render "+00:00"), so
  # this is spelled out with strftime instead of relying on either one to
  # happen to match.
  def self.build_time_xmlschema
    @build_time_xmlschema ||= Time.now.strftime("%Y-%m-%dT%H:%M:%S%:z")
  end

  def build_time_xmlschema
    MachineHelper.build_time_xmlschema
  end

  # jekyll-feed's "smartify" filter runs a title through Kramdown's
  # SmartyPants-only parser (typographic quotes/dashes, no block markup).
  # A full Kramdown render produces the same result for any title with no
  # markdown syntax in it, which is true of every title in this corpus, so
  # this reuses the same renderer the rest of the app already proved
  # correct rather than reimplementing Jekyll's SmartyPants parser.
  # ponytail: full markdownify instead of SmartyPants-only, wrong only if a
  # future title contains real markdown syntax (bold, links, backticks).
  def feed_smartify(text)
    strip_tags(MarkdownRenderer.render(text.to_s)).squish
  end

  # Jekyll::Document#generate_excerpt only builds a rendered Jekyll::Excerpt
  # when front matter declares none (`data["excerpt"] ||= Excerpt.new(...)`).
  # A post with its own "excerpt:" front matter never goes through that
  # branch, so `post.excerpt` in Liquid is the literal front-matter string,
  # not run through Kramdown at all (no smart quotes, no <p> wrapper).
  def excerpt_text(document)
    document.front_matter["excerpt"].presence || document.excerpt_html
  end

  # === sitemap.xml =========================================================

  # sitemap.xml.liquid's page loop wraps its "<url>...</url>" body in an
  # {% if %}, so every site.pages entry (matching or not) leaves behind a
  # "\n  " before AND after its turn, not just the matching ones:
  # {% for page %}\n  {% if ... %}\n  <url>...</url>\n  {% endif %}\n  {% endfor %}.
  # A page that fails the condition (Jekyll's own feed.xml/sitemap.xml/
  # llms.txt pages, and the two Sass entry points its converter also
  # registers as pages) contributes that empty "\n  \n  " with no <url>
  # block. MachineController#sitemap_page_entries builds the same sequence
  # of :skip / [:page, url] tokens that site.pages carried, in the same
  # positions, so this only has to render each token, not know why it is
  # there.
  def sitemap_xml(posts, page_entries)
    build_time = build_time_xmlschema

    xml = +%(<?xml version="1.0" encoding="UTF-8"?>\n)
    xml << %(<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">\n  )

    posts.each do |post|
      xml << "\n  <url>\n    <loc>#{Site.url}#{post.url}</loc>\n    <lastmod>#{post.date.iso8601}</lastmod>\n    <changefreq>monthly</changefreq>\n    <priority>0.8</priority>\n  </url>\n  "
    end

    xml << "  \n  "

    page_entries.each do |entry|
      body =
        if entry == :skip
          ""
        else
          _, url = entry
          "\n  <url>\n    <loc>#{Site.url}#{url}</loc>\n    <lastmod>#{build_time}</lastmod>\n    <changefreq>monthly</changefreq>\n    <priority>0.5</priority>\n  </url>\n  "
        end
      xml << "\n  #{body}\n  "
    end

    xml << "\n</urlset>"
    xml
  end

  # === feed.xml =============================================================

  def feed_xml(posts)
    build_time = build_time_xmlschema
    self_url = "#{Site.url}/feed.xml"
    title = xml_escape(feed_smartify(Site.title))

    xml = +%(<?xml version="1.0" encoding="utf-8"?>)
    xml << %(<feed xmlns="http://www.w3.org/2005/Atom" >)
    xml << %(<generator uri="https://jekyllrb.com/" version="4.4.1">Jekyll</generator>)
    xml << %(<link href="#{self_url}" rel="self" type="application/atom+xml" />)
    xml << %(<link href="#{Site.url}/" rel="alternate" type="text/html" />)
    xml << "<updated>#{build_time}</updated>"
    xml << "<id>#{xml_escape(self_url)}</id>"
    xml << %(<title type="html">#{title}</title>)
    xml << "<subtitle>#{xml_escape(Site.description)}</subtitle>"
    xml << %(<author><name>#{xml_escape(Site.author_name)}</name><email>#{xml_escape(Site.author_email)}</email></author>)
    posts.first(10).each { |post| xml << feed_entry_xml(post) }
    xml << "</feed>"
    xml
  end

  def feed_entry_xml(post)
    title = xml_escape(feed_smartify(post.title))
    url = "#{Site.url}#{post.url}"
    id = xml_escape("#{Site.url}#{post.url.chomp('/')}")
    image = xml_escape("#{Site.url}#{post.image}")

    entry = +"<entry>"
    entry << %(<title type="html">#{title}</title>)
    entry << %(<link href="#{url}" rel="alternate" type="text/html" title="#{title}" />)
    entry << "<published>#{post.date.iso8601}</published>"
    entry << "<updated>#{post.last_modified_at.iso8601}</updated>"
    entry << "<id>#{id}</id>"
    entry << %(<content type="html" xml:base="#{xml_escape(url)}"><![CDATA[#{post.html.strip}]]></content>)
    entry << feed_author_xml(post)
    post.tags.each { |tag| entry << %(<category term="#{xml_escape(tag)}" />) }
    summary = strip_tags((post.description || excerpt_text(post)).to_s).squish
    entry << %(<summary type="html"><![CDATA[#{summary}]]></summary>)
    entry << %(<media:thumbnail xmlns:media="http://search.yahoo.com/mrss/" url="#{image}" />)
    entry << %(<media:content medium="image" url="#{image}" xmlns:media="http://search.yahoo.com/mrss/" />)
    entry << "</entry>"
    entry
  end

  # A post with its own front-matter "author:" (a plain String, not a
  # site.data.authors lookup this repo has no data file for) reports only
  # that name, with no email: jekyll-feed resolves post_author_email via
  # `post_author.email`, and a String has no such property.
  def feed_author_xml(post)
    if post["author"]
      "<author><name>#{xml_escape(post["author"])}</name></author>"
    else
      %(<author><name>#{xml_escape(Site.author_name)}</name><email>#{xml_escape(Site.author_email)}</email></author>)
    end
  end

  # === llms.txt =============================================================

  def llms_txt(pages, posts)
    lines = [
      "# #{Site.author_name}",
      "",
      "> #{Site.description.to_s.delete("\n").strip}",
      "",
      "## Pages",
      *pages.map { |page| llms_page_line(page) },
      "",
      "## Posts",
      *posts.map { |post| llms_post_line(post) },
      "",
      "## Optional",
      "- [Archive](#{Site.url}/archive/): Every post in reverse chronological order.",
      "- [Tags](#{Site.url}/tags/): Posts grouped by topic.",
      "- [Feed](#{Site.url}/feed.xml): Atom feed of all posts."
    ]
    "#{lines.join("\n")}\n"
  end

  def llms_page_line(page)
    description = page.description.presence
    suffix = description ? ": #{strip_tags(description).delete("\n").strip}" : ""
    "- [#{page.title}](#{Site.url}#{page.url})#{suffix}"
  end

  def llms_post_line(post)
    excerpt = strip_tags(excerpt_text(post).to_s).delete("\n").strip
    "- [#{post.title}](#{Site.url}#{post.url})#{llms_truncate(excerpt)}"
  end

  # Liquid's `truncate: 160` filter: cut to 160 chars including the "..."
  # suffix, only when the input is actually longer than that.
  def llms_truncate(text, length: 160, omission: "...")
    return "" if text.empty?
    return ": #{text}" if text.length <= length

    ": #{text[0, length - omission.length]}#{omission}"
  end
end
