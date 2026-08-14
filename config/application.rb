require_relative "boot"

require "rails"
require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

module Blog
  class Application < Rails::Application
    config.load_defaults 8.1

    # No database, no jobs, no mail, no storage. Only the three railties above
    # are required, which is what keeps boot near a second.
    config.autoload_lib(ignore: %w[tasks])

    # The site publishes no forms and stores no sessions, so there is no secret
    # to protect. A real value here would be security theatre in a static build.
    config.secret_key_base = "0"

    # Production renders dates as +00:00 because CI runs in UTC. Pin it so a
    # local build cannot disagree with what is already published.
    config.time_zone = "UTC"
  end
end
