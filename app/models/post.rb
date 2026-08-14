class Post < Document
  FILENAME = /\A_posts\/(\d{4})-(\d{2})-(\d{2})-(?<slug>.+)\.md\z/

  def self.glob = "_posts/*.md"

  # Ruby's sort_by does not promise stability, so a same-day pair could
  # reorder from run to run without an explicit tie-break. Jekyll's own
  # descending post order (Jekyll::Drops::SiteDrop#posts, "b <=> a" on
  # Jekyll::Document#<=>) breaks a date tie by path, descending. Sorting
  # ascending on [date, path] and reversing the whole array reproduces that
  # exactly, since path is unique per post and needs no stability to land
  # in the right order.
  def self.all
    super.sort_by { |post| [post.date, post.path] }.reverse
  end

  def kind = :post

  def slug
    @slug ||= FILENAME.match(path)[:slug]
  end

  def url
    permalink || "/#{slug}/"
  end

  def date
    @date ||= begin
      declared = front_matter["date"]
      declared ? declared.to_time : Date.parse(path[/\d{4}-\d{2}-\d{2}/]).to_time
    end
  end
end
