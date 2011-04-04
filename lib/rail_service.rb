require "rail_service/railtie" if defined?(Rails)

module RailService
  autoload :API, "rail_service/api"
  autoload :Endpoint, "rail_service/endpoint"
  autoload :Railtie, "rail_service/railtie"
  autoload :ShowExceptions, "rail_service/show_exceptions"
  autoload :VERSION, "rail_service/version"

  module Generators
    autoload :ApiGenerator, "rail_service/generators/api_generator"
  end

  def self.configure
  end
end
