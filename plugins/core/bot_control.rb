require_relative '../../lib/helpers/identification'

module Cinch
  module Plugins
    class BotControl
      include Cinch::Plugin
      
      set :prefix, eval(YAML.load_file('config/settings/settings.yaml')['prefix'])
      
      match /off/i, method: :off 
      
      def off(m)
        plugin_name = "BotControl"
        log_message("message", "Received 'off' command from #{m.user.nick}...", plugin_name)
        bot.quit("on command of #{m.user.nick}. Exiting normally...")
      end
      
      match /restart/i, method: :restart
      
      def restart(m)
        plugin_name = "BotControl"
        log_message("message", "Received 'restart' command from #{m.user.nick}...", plugin_name)
        IO.popen("kill #{Process.pid} && ruby Eve.rb&")
      end
    end
  end
end