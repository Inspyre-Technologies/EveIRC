require_relative '../../lib/helpers/authentication'
require_relative '../../lib/helpers/quit'

module Cinch
  module Plugins
    class BotControl
      include Cinch::Plugin

      set :prefix, eval(YAML.load_file('config/settings/settings.yaml')['prefix'])

      match /off/i, method: :off

      def off(m)
        return unless authentication(m)
        quit_safely
        plugin_name = "BotControl"
        log_message("message", "Received 'off' command from #{m.user.nick}...", plugin_name)
        exit_normally
        bot.quit("on command of #{m.user.nick}. Exiting normally...")
      end

      match /restart/i, method: :restart

      def restart(m)
        return unless authentication(m)
        plugin_name = "BotControl"
        log_message("message", "Received 'restart' command from #{m.user.nick}...", plugin_name)
        system("kill #{Process.pid} && ruby Eve.rb")
      end
    end
  end
end