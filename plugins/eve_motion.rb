require 'yaml'
require 'cinch'

module Cinch
  module Plugins
    class EveMotion
      include Cinch::Plugin
      
      def initialize(*args)
        super
        if File.exist?('config/settings/eveMotion.yaml')
          @aiSettings = YAML.load_file('config/settings/eveMotion.yaml')
        else
          load 'lib/utils/ai_config.rb'
          AiConfig.new(*args)
        end
      end
    end
  end
end