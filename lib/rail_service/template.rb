remove_dir "public"
remove_dir "app/mailers"
remove_dir "app/helpers"
remove_dir "app/controllers"
remove_dir "app/views"
remove_dir "test"
remove_dir "doc"
remove_dir "lib"
remove_dir "config/locales"
remove_dir "vendor"
remove_dir "tmp"
remove_file "log/test.log"
remove_file "log/development.log"
remove_file "log/production.log"
remove_file "log/server.log"
remove_file "config/initializers/secret_token.rb"
remove_file "config/initializers/session_store.rb"
remove_file "config/initializers/mime_types.rb"
remove_file "config/routes.rb"
remove_file "README"

empty_directory "app/api"
empty_directory "client/lib/#{app_name}"
file "client/lib/#{app_name}.rb"
file "client/#{app_name}.gemspec"

gsub_file "config/application.rb", "require 'rails/all'", <<-RUBY.strip
require "rails"
require "active_record/railtie"
require "action_controller/railtie"
RUBY

gsub_file "config/environments/test.rb", "  config.action_mailer", "  # config.action_mailer"
gsub_file "config/environments/development.rb", "  config.action_mailer", "  # config.action_mailer"

gem "rail_service"

initializer "rail_service.rb", <<-RUBY
require "rail_service"

RailService.configure do |config|
  config.require_ssl = false
end
RUBY
