require "rails"
require "rail_service"

module RailService
  class Railtie < Rails::Railtie
    initializer "rail_service.setup_middlewares" do |app|
      app.middleware.delete ActionDispatch::Static

      # require "rail_service/show_exceptions"
      # app.middleware.swap ActionDispatch::ShowExceptions, RailService::ShowExceptions

      app.middleware.delete ActionDispatch::Cookies
      app.middleware.delete ActionDispatch::Session::CookieStore
      app.middleware.delete ActionDispatch::Flash
      app.middleware.delete Rack::MethodOverride
      app.middleware.delete ActionDispatch::BestStandardsSupport
    end
  end
end
