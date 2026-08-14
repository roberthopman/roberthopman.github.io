Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  # Parklife fetches through Rack, so public/ must be served during the crawl.
  config.public_file_server.enabled = true

  config.force_ssl = false
  config.log_level = "warn"
end
