require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tab002
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.x.balance_cap = -500

    config.active_record.raise_in_transactional_callbacks = true
    config.active_job.queue_adapter = :delayed_job
    config.call_api_after = 5.minutes
    config.frecency_num_orders = 100

    config.middleware.insert_before 0, "Rack::Cors" do
      allow do
        origins 'localhost:8000', 'localhost:8001'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
  end
end
