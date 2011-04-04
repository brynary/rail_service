require "rails"
require "rail_service"

module RailService
  class Railtie < Rails::Railtie

    initializer "rail_service.delete_middlewares" do |app|
      app.middleware.delete ActionDispatch::Static
      app.middleware.delete ActionDispatch::Cookies
      app.middleware.delete ActionDispatch::Session::CookieStore
      app.middleware.delete ActionDispatch::Flash
      app.middleware.delete Rack::MethodOverride
      app.middleware.delete ActionDispatch::BestStandardsSupport
    end

    initializer "rail_service.swap_exception_handling" do |app|
      app.middleware.swap ActionDispatch::ShowExceptions, RailService::ShowExceptions
    end

    initializer "rail_service.add_to_load_path", :before => :set_load_path do |app|
      app.config.eager_load_paths << Rails.root.join("app", "api")
      app.config.autoload_paths << Rails.root.join("app", "api")
    end

    initializer "rail_service.set_routes_reloader" do |app|
      Dir[Rails.root.join("app", "api", "**", "*.rb").expand_path].each do |api|
        app.routes_reloader.paths << api
      end
    end

    generators do
      require "rail_service/generators/api_generator"
    end

  end
end
