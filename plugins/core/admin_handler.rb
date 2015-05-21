require 'yaml'
require 'highline/import'
require_relative '../../lib/helpers/authentication'
require_relative '../../lib/helpers/file_handler'

module Cinch
  module Plugins
    class AdminHandler
      include Cinch::Plugin

      set :prefix, eval(YAML.load_file('config/settings/settings.yaml')['prefix'])

      match /status/i, method: :status

      def status(m)
        logged_in = $admin_file[User(m.user).nick.downcase]['currently']
        if logged_in == false
          m.user.send "You are not currently logged into the bot."
        end
        if logged_in == true
          m.user.send "You are currently logged into the bot."
        end
      end

      match /login$/i, method: :login

      def login(m)
        if authentication(m)
          m.reply "You are currently logged into the bot."
          timeout_handler(m)
        else
          m.reply "You are not logged into the bot."
        end
      end

      def timeout_handler(m, option="start")
        if option == "start"
          @timeout_timer.stop if @timeout_timer
          @timeout_timer = Timer(1800, shots: 1) { login(m) }
        else
          @timeout_timer.stop
        end
      end

      match /logout (.+)/i, method: :logout

      def logout(m, user, reason="user defined")
        if reason == "user defined"
          $admin_file[User(m.user).nick.downcase]['currently'] = false
          timeout_handler(m, "stop")
          m.user.send "You have been logged out of the bot!"
          write_admin_file
        else
          m.user.send "Your session has timed out. Please log back in when you're ready!"
          $admin_file[User(m.user).nick.downcase]['currently'] = false
          write_admin_file
        end
      end
    end
  end
end

