module RailService
  module Generators
    class ApiGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __FILE__)

      def create_api_file
        template 'api.rb', File.join('app/api', class_path, "#{file_name}_api.rb")
      end

    end
  end
end
