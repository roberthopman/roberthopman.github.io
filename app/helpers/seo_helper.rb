module SeoHelper
  def seo_tags(document)
    tags = []
    tags << tag.title(seo_title(document))
    tags << tag.meta(property: "og:title", content: document.title || Site.title)
    tags << tag.meta(name: "author", content: Site.author_name)
    tags << tag.meta(property: "og:locale", content: "en_US")
    tags << tag.meta(name: "description", content: seo_description(document))
    tags << tag.meta(name: "twitter:description", property: "og:description",
                     content: seo_description(document))
    tags << tag.link(rel: "canonical", href: absolute(document.url))
    tags << tag.meta(property: "og:url", content: absolute(document.url))
    tags << tag.meta(property: "og:site_name", content: Site.title)
    tags << tag.meta(property: "og:image", content: absolute(document.image))
    tags << tag.meta(property: "og:type", content: document.kind == :post ? "article" : "website")

    if document.kind == :post
      tags << tag.meta(property: "article:published_time", content: document.date.iso8601)
      tags << tag.meta(property: "article:modified_time", content: document.last_modified_at.iso8601)
    end

    tags << tag.meta(name: "twitter:card", content: "summary_large_image")
    tags << tag.meta(name: "twitter:image", content: absolute(document.image))
    tags << tag.meta(name: "twitter:title", content: document.title || Site.title)
    tags << json_ld(document)

    safe_join(tags, "\n")
  end

  private

  def seo_title(document)
    return "#{Site.title} | #{Site.description}" if document.url == "/"

    "#{document.title} | #{Site.title}"
  end

  def seo_description(document)
    document.description.presence || document.front_matter["excerpt"].presence || Site.description
    # Reads front_matter directly, not excerpt_source: jekyll-seo-tag falls back
    # to a declared excerpt only, never to a derived one.
  end

  def absolute(path)
    path.start_with?("http") ? path : "#{Site.url}#{path}"
  end

  def json_ld(document)
    data = {
      "@context" => "https://schema.org",
      "@type" => schema_type(document),
      "author" => { "@type" => "Person", "name" => Site.author_name, "url" => Site.author_url },
      "description" => seo_description(document),
      "headline" => document.title || Site.title,
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

  def schema_type(document)
    return "WebSite" if document.url == "/"

    document.kind == :post ? "BlogPosting" : "WebPage"
  end
end
