require "cgi"

module SeoHelper
  # The pixel size of Site.image. Declaring it lets a crawler reserve the card
  # layout without fetching the file. Only emitted when a document uses the
  # site default: a document carrying its own image would need its own
  # measurements, and no document does today. test/documents_test.rb pins
  # these numbers against the real file, so the tags cannot start lying.
  SITE_IMAGE_SIZE = { width: 1200, height: 630 }.freeze

  def seo_tags(document)
    page_title = seo_page_title(document)

    tags = []
    tags << tag.title(seo_title(page_title))
    tags << tag.meta(property: "og:title", content: page_title)
    tags << tag.meta(name: "author", content: Site.author_name)
    tags << tag.meta(property: "og:locale", content: "en_US")
    tags << tag.meta(name: "description", content: seo_description(document))
    tags << tag.meta(name: "twitter:description", property: "og:description",
                     content: seo_description(document))
    tags << tag.link(rel: "canonical", href: absolute(document.url))
    tags << tag.meta(property: "og:url", content: absolute(document.url))
    tags << tag.meta(property: "og:site_name", content: Site.title)
    tags << tag.meta(property: "og:image", content: absolute(document.image))
    if document.image == Site.image
      tags << tag.meta(property: "og:image:width", content: SITE_IMAGE_SIZE[:width])
      tags << tag.meta(property: "og:image:height", content: SITE_IMAGE_SIZE[:height])
    end
    tags << tag.meta(property: "og:type", content: document.kind == :post ? "article" : "website")

    if document.kind == :post
      tags << tag.meta(property: "article:published_time", content: document.date.iso8601)
      tags << tag.meta(property: "article:modified_time", content: document.last_modified_at.iso8601)
    end

    tags << tag.meta(name: "twitter:card", content: "summary_large_image")
    tags << tag.meta(name: "twitter:image", content: absolute(document.image))
    tags << tag.meta(name: "twitter:title", content: page_title)
    tags << json_ld(document, page_title)

    safe_join(tags, "\n")
  end

  private

  # jekyll-seo-tag's page_title: the document's own title, run through
  # markdownify + strip_html + normalize_whitespace, falling back to the
  # site title when the document declares none.
  def seo_page_title(document)
    format_string(document.title) || Site.title
  end

  # jekyll-seo-tag's <title>: "page title | site title", unless there is no
  # page title of its own (page_title then equals site_title), in which case
  # it falls back to "site title | site description" instead.
  def seo_title(page_title)
    return "#{page_title} | #{Site.title}" if page_title != Site.title

    "#{Site.title} | #{Site.description}"
  end

  def seo_description(document)
    value = format_string(document.description) ||
      format_string(document_excerpt(document)) ||
      Site.description
    snippet(value, description_max_words(document))
  end

  # jekyll-seo-tag caps the description at 100 words, or at a page's own
  # front_matter["seo_description_max_words"] when it sets one.
  def description_max_words(document)
    document.front_matter["seo_description_max_words"] || 100
  end

  # jekyll-seo-tag's own truncation: split on whitespace, keep the first
  # max_words pieces, and append a single "…" (not three dots) only when
  # something was actually cut.
  def snippet(string, max_words)
    return string if string.nil?

    result = string.split(/\s+/, max_words + 1)[0...max_words].join(" ")
    result.length < string.length ? "#{result}…" : result
  end

  # Jekyll gives every post an automatic excerpt (the first paragraph of the
  # body) when none is declared in front matter. Pages carry no such
  # feature: an undeclared page excerpt is simply absent, not derived from
  # the body.
  def document_excerpt(document)
    return document.excerpt_source if document.kind == :post

    document.front_matter["excerpt"]
  end

  def absolute(path)
    path.start_with?("http") ? path : "#{Site.url}#{path}"
  end

  def json_ld(document, page_title)
    data = {
      "@context" => "https://schema.org",
      "@type" => schema_type(document),
      "author" => json_ld_author(document),
      "description" => seo_description(document),
      "headline" => page_title,
      "image" => absolute(document.image),
      "url" => absolute(document.url)
    }

    if document.kind == :post
      data["dateModified"] = document.last_modified_at.iso8601
      data["datePublished"] = document.date.iso8601
      data["mainEntityOfPage"] = { "@type" => "WebPage", "@id" => absolute(document.url) }
    elsif document.url == "/"
      data["name"] = Site.author_name
      data["sameAs"] = Site.social_links
    else
      data["dateModified"] = document.last_modified_at&.iso8601
    end

    # jekyll-seo-tag emits the object with its keys sorted, on its own line
    # inside the script tag.
    content_tag(:script, raw("\n#{data.compact.sort.to_h.to_json}"), type: "application/ld+json")
  end

  # jekyll-seo-tag resolves the author's url through site.data.authors
  # whenever a document sets its own front_matter["author"], even to the
  # site author's own name: that lookup is by string key, and this site
  # defines no _data/authors.yml, so the url comes back nil and gets
  # dropped. Only a document with no author of its own reuses the
  # site-level author's url.
  def json_ld_author(document)
    author = document.front_matter["author"]
    hash = { "@type" => "Person", "name" => json_ld_author_name(author) }
    hash["url"] = Site.author_url unless author
    hash
  end

  # The real drop takes the name from the document's own declared author
  # when it has one, else the site author. A document's author can in
  # principle be an Array (see _includes/page-header.html), but neither
  # this repo nor the real drop resolves that case, so anything but a
  # String falls back to the site author.
  def json_ld_author_name(author)
    author.is_a?(String) ? author : Site.author_name
  end

  def schema_type(document)
    return "WebSite" if document.url == "/"

    document.kind == :post ? "BlogPosting" : "WebPage"
  end

  # jekyll-seo-tag's format_string: markdownify, strip_html, normalize
  # whitespace. Markdownify is what turns a straight "isn't" into a
  # kramdown-smartened "isn't", and what turns a heading like "## Open
  # source" into plain "Open source" for an excerpt with no explicit
  # front matter value. strip_tags leaves any entities kramdown escaped
  # (e.g. "&" as "&amp;") as literal text, so they are decoded back before
  # the caller's own HTML-attribute escaping runs once, not twice.
  def format_string(value)
    return nil if value.blank?

    CGI.unescapeHTML(strip_tags(MarkdownRenderer.render(value.to_s))).squish
  end
end
