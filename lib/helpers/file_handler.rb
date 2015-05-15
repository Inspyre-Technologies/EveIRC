require 'cinch'
require 'yaml'
require_relative 'logger'

module Cinch
  module Helpers

    Helper_Name = "Helper::FileHandler"

    $admin_file = YAML.load_file('config/settings/masters.yaml') if File.exist?('config/settings/masters.yaml')
    $settings_file = YAML.load_file('config/settings/settings.yaml') if File.exist?('config/settings/settings.yaml')
    $path_file = YAML.load_file('config/settings/paths.yaml') if File.exist?('config/settings/paths.yaml')
    if File.exist?('config/settings/user_info.yaml')
      $user_file = YAML.load_file('config/settings/user_info.yaml')
    else
      $user_file = false
    end

    def file_writer(title, file, array_var)
      log_message("message", "Writing #{title} file...", Helper_Name)
      begin
        synchronize(:update) do
          path = "config/settings/"
          File.open("#{path}#{file}", 'w') do |fh|
            YAML.dump(array_var, fh)
          end
        end
      rescue
        log_message("error", "#{$!}", Helper_Name)
        abort("Error creating file: #{file}")
      end
      log_message("message", "Successfully saved #{title}!", Helper_Name)
    end
  end
end