require 'yaml'
require 'json'
require 'tempfile'

module Cinch
  module Plugins
    class ConfigChecks
      include Cinch::Plugin
      
      # This block checks for several files, and
      # if they are not there it will run the first-
      # run wizard for the associated core plugin.
      #
      # The files checked are as follows
      # - settings.yaml (basic bot settings)
      # - masters.yaml (administrator settings)
      # - plugins.rb (the final require script)
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