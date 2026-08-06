# Generates one page per tag, replacing the hand-maintained tags/*.md files.
#
# Those files drifted: 20 tags used on posts and pages had no corresponding
# file and returned 404, while 8 files existed for tags nothing used and
# rendered as empty pages. Generating them removes that whole class of bug.
#
# Custom plugins only run because the site builds via GitHub Actions with its
# own Gemfile. They are ignored under Pages' legacy branch builds.
#
# The permalink is slugified (Jekyll's own Utils.slugify, matching what
# tags.md and _includes/page-header.html use), but page.tag keeps the ORIGINAL
# string, because _layouts/tag.html looks up site.tags[page.tag] and
# "p.tags contains page.tag", both of which key on the unslugified value.
module Jekyll
  class TagPageGenerator < Generator
    safe true
    priority :low

    def generate(site)
      tags = {}

      # Snapshot before appending, or we would iterate what we are adding.
      documents = site.posts.docs + site.pages.dup

      documents.each do |doc|
        Array(doc.data["tags"]).each do |raw|
          name = raw.to_s.strip
          next if name.empty?

          slug = Utils.slugify(name)
          next if slug.nil? || slug.empty?

          # First spelling wins, so "git grep" and "Git Grep" collapse to one
          # page rather than fighting over the same permalink.
          tags[slug] ||= name
        end
      end

      tags.each { |slug, name| site.pages << TagPage.new(site, slug, name) }
    end
  end

  class TagPage < PageWithoutAFile
    def initialize(site, slug, name)
      super(site, site.source, File.join("tags", slug), "index.html")
      data["layout"] = "tag"
      data["title"] = "Tag: #{name}"
      data["tag"] = name
      data["permalink"] = "/tags/#{slug}/"
    end
  end
end
