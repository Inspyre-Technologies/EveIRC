require 'cinch'
require 'yaml'

module Cinch
  module Plugins
    class ChannelControl
      include Cinch::Plugin
      
      set :prefix, eval(YAML.load_file('config/settings/settings.yaml')['prefix'])
      
      def plugin_name
        return "ChannelControl"
      end
      
      match /join (.+)/i, method: :join
      
      def join(m, channel)
        log_message("message", "Received 'join' command from #{m.user.nick} for #{channel}...")
        m.reply "Very well, joining #{channel}..."
        Channel(channel).join
      end
      
      match /part (.+)/i, method: :part
      
      def part(m, channel)
        log_message("message", "Received 'part' command from #{m.user.nick} for #{channel}...")
        m.reply "Very well, parting #{channel}..."
        Channel(channel).part
      end
      
      match /hop (.+)/i, method: :hop
      
      def hop(m, channel)
        log_message("message", "Received 'hop' command from #{m.user.nick} for #{channel}...")
        m.reply "Very well, parting and joining #{channel}..."
        Channel(channel).part
        Channel(channel).join
      end
      
    end
  end
end