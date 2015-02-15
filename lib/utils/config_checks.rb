require 'yaml'
require 'bcrypt'
require 'highline/import'
require 'json'
require 'fileutils'
require 'tempfile'

module Cinch
  module Plugins
    class ConfigChecks
      include Cinch::Plugin
      
      def initialize(*args)
        super
        if File.exist?('config/settings/settings.yaml')
          @settings = YAML.load_file('config/settings/settings.yaml')
        else
          load 'lib/utils/first_run.rb'
          FirstRun.new(*args)
        end
        if File.exist?('config/settings/masters.yaml')
          @masterFile = YAML.load_file('config/settings/masters.yaml')
          @masterHistory = YAML.load_file('config/settings/logged.yaml')
        else
          load 'lib/utils/admin_first_run.rb'
          AdminFirstRun.new(*args)
        end
        if File.exist?('config/settings/plugins.rb')
          puts "Plugins file exists...starting bot."
        else
          load 'lib/utils/plugins_first_run.rb'
          PluginsFirstRun.new(*args)
        end
      end
    end
  end
end