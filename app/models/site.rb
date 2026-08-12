module Site
  module_function

  def config
    @config ||= YAML.load_file(Rails.root.join("_config.yml"))
  end

  def data(name)
    @data ||= {}
    @data[name] ||= YAML.load_file(Rails.root.join("_data", "#{name}.yml"))
  end

  def title = config["title"]
  def description = config["description"]
  def url = config["url"]
  def image = config["image"]
  def legal_entity = config["legal_entity"]
  def google_analytics = config["google_analytics"]
  def discourse_url = config.dig("discourse", "url")
  def author_name = config.dig("author", "name")
  def author_email = config.dig("author", "email")
  def author_url = config.dig("author", "url")
  def social_links = config.dig("social", "links") || []
  def header_pages = config["header_pages"] || []
end
