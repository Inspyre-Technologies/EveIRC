require 'yaml'
require 'bcrypt'
require 'highline/import'
require_relative '../../lib/helpers/identification'

module Cinch
  module Plugins
    class AdminHandler
      include Cinch::Plugin
      
      set :prefix, eval(YAML.load_file('config/settings/settings.yaml')['prefix'])
      
      def initialize(*args)
        super
        if File.exist?('config/settings/masters.yaml')
          @masterFile = YAML.load_file('config/settings/masters.yaml')
          @masterHistory = YAML.load_file('config/settings/logged.yaml')
        else
          abort("Critical error")
        end
      end

              
      match /status/i, method: :status
      
      def status(m)
        loggedIn = @masterHistory[User(m.user).nick]['currently']
        if loggedIn == false
          m.user.send "You are not currently logged into the bot."
        end
        if loggedIn == true
          m.user.send "You are currently logged into the bot."
        end
      end
      
      match /login (.+?) (.+)/i, method: :login
      
      def login(m, user, pass)
        if user != User(m.user).nick
          user = user
        else
          user = User(m.user).nick
        end
        auth = check_method(m.user)
        if auth == "User not found"
          auth = check_method(user)
        end
        if auth == "2FA"
          return m.user.send "Your credentials are incorrect. Access denied!" if !login_2fa(user, pass)
          if login_2fa(user, pass)
            m.user.send "Access granted, logging you in!"
            @masterHistory[user]['currently'] = true
            update_history
            timeoutHandler(m, user)
            m.user.send "You are logged in!"
          end
        end
        if auth == "PASS"
          return m.user.send "Your credentials are incorrect. Access denied!" if !login_pass(user, pass)
          if login_pass(user, pass)
            m.user.send "Access granted, logging you in!"
            @masterHistory[user]['currently'] = true
            update_history
            timeoutHandler(m, user)
            m.user.send "You are logged in!"
          end
        end
        if auth == "nsFS"
          return m.user.send "Your credentials are incorrect. Access denied!" if login_nsFS(m, user, pass) == false
          if login_nsFS(m, user, pass) == "fs"
            m.user.send "Access granted, logging you in!"
            @masterHistory[user]['currently'] = true
            update_history
            timeoutHandler(m, user)
            m.user.send "You are logged in!"
          end
          if login_nsFS(m, user, pass) == "ns"
            return m.user.send "You are already logged in via NickServ! There's no need for you to login with a fail-safe!"
          end
        end
      end
      
      match /login$/i, method: :loginNS
      
      def loginNS(m)
        m.user.refresh
        return m.user.send "You are not authed with NickServ!" if m.user.authname.nil?
        if check_method(m.user) == "NS"
          if @masterFile[m.user.nick]['authname'] == m.user.authname.downcase
            @masterHistory[m.user.nick]['currently'] = true
            update_history
            m.user.send "You are logged into the bot."
            timeoutHandler(m, User(m.user).nick, "NS", "start")
          else
            m.user.send "You are not logged into NickServ!"
          end
        end
      end
      
      def timeoutHandler(m, user, login_method="nonNS", option="start")
        if option == "start"
          if login_method == "NS"
            @timeoutTimer = Timer(1800, shots: 1) { check_ns(m) }
          else
            @timeoutTimer = Timer(3600, shots: 1) { logout(m, user, "timeout") }
          end
        else
          @timeoutTimer.stop
        end
      end
      
      def check_ns(m)
        m.user.refresh
        if User(m.user).authname
          if @masterFile[User(m.user).nick]['authname'] == User(m.user).authname.downcase
          timeoutHandler(m, User(m.user).nick, "NS")
          else
            @masterHistory[User(m.user).nick]['currently'] = false
            m.user.send "You've been logged out of the bot because you're no longer authed with NickServ."
          end
        else
          @masterHistory[User(m.user).nick]['currently'] = false
          m.user.send "You've been logged out of the bot because you're no longer authed with NickServ."
        end
      end
      
      match /logout (.+)/i, method: :logout
      
      def logout(m, user, reason="user defined")
        if reason == "user defined"
          @masterHistory[User(user).nick]['currently'] = false
          timeoutHandler(m, user, "stop")
          m.user.send "You have been logged out of the bot!"
          update_history
        else
          m.user.send "Your session has timed out. Please log back in when you're ready!"
          @masterHistory[User(user).nick]['currently'] = false
          update_history
        end
      end
      
      def update_history
        begin
          synchronize(:update) do
            File.open('config/settings/logged.yaml', 'w') do |fh|
              YAML.dump(@masterHistory, fh)
            end
          end
        rescue
          puts "#{$!}"
          abort("Eror creating file: logged.yaml")
        end
      end
      
    end
  end
end

