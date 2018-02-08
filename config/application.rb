require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ExposedApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.beginning_of_week = :monday

    config.autoload_paths << "#{Rails.root}/app/exceptions"
    config.autoload_paths << "#{Rails.root}/lib"

    config.generators do |g|
      g.test_framework :rspec
      g.assets  false
      g.helper false
      g.stylesheets false
      g.template_engine :erb
      g.scaffold_controller :scaffold_controller
    end

    config.time_zone = "Europe/Paris"
    config.active_record.default_timezone = :utc
  end
end
