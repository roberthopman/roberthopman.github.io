class Post < Document
  FILENAME = /\A_posts\/(\d{4})-(\d{2})-(\d{2})-(?<slug>.+)\.md\z/

  def self.glob = "_posts/*.md"

  def self.all
    super.sort_by(&:date).reverse
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
