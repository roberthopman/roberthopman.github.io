module ApplicationHelper
  # archive.md and tags.md no longer exist as Page files (Task 7 replaced
  # them with views), but config/site.yml's header_pages still names them by
  # path, so the site nav needs their title/url from somewhere else.
  HEADER_VIRTUAL_PAGES = {
    "archive.md" => ["Archive", "/archive/"],
    "tags.md" => ["Tags", "/tags/"]
  }.freeze

  def header_link(path)
    HEADER_VIRTUAL_PAGES[path] || begin
      page = Page.all.find { |candidate| candidate.path == path }
      [page&.title, page&.url]
    end
  end
end
