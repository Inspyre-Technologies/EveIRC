require 'yaml'
require 'bcrypt'
require 'highline/import'
require_relative '../lib/helpers/identification'

module Cinch
  module Plugins
    class AdminHandler
      include Cinch::Plugin
      
      def initialize(*args)
        super
        if File.exist?('config/settings/masters.yaml')
          @masterFile = YAML.load_file('config/settings/masters.yaml')
          @masterHistory = YAML.load_file('config/settings/logged.yaml')
        else
          @masterFile = {}
          @masterHistory = {}
          puts "Hello, I am Eve!"
          if agree("We are now going to run a first-run configuration, are you ready? [yes/no]: ")
            nickname = ask("First off, tell me what nickname you use on IRC: ") { |q| 
                                                                                  q.validate = /\A\w+\Z/ 
                                                                                q.responses[:not_valid] = "You can't have a blank IRC nickname!"
                                                                                q.responses[:ask_on_error] = "The nickname that you use on IRC: "
                                                                                q.confirm = "Are you sure you wish to set your nickname as <%= @answer %> [yes/no]: "
                                                                                }
            @masterFile[nickname.to_s] ||= {}
            puts "Excellent! Thank you #{nickname}!"
          else
            abort("Thank you for using Eve. Come back when you're ready!")
          end
          begin
            say("\nYou have several options for indentifying to the bot on IRC;")
            choose do |menu|
              menu.prompt = "Please choose one of the above security options: "
              menu.choice("Two-factor authentication") do enable_2fa(nickname) end
              menu.choice("Password authentication") do enable_pass(nickname) end
              menu.choice("NickServ authentication") do enable_ns(nickname) end
              menu.choice("NickServ authentication w/ fail-safe password") do enable_nsFS(nickname) end
            end
          rescue
            puts "#{$!}"
            retry
          end
          update_store
          @masterHistory[nickname.to_s] ||= {}
          @masterHistory[nickname.to_s]['creation_date'] = Time.now
          @masterHistory[nickname.to_s]['currently'] = false
          update_history
        end
      end

      def enable_2fa(nickname)
        puts "\n\nYou've selected two-factor authentication. This means that you will have to authenticate with NickServ AND provide a password to identify to the bot."
        raise ArgumentError.new("You've indicated that you're not sure whether you want to use two-factor authentication, returning...") if !agree("Are you sure this is the method you want? [yes/no] ")
        
        @masterFile[nickname]['authentication'] = "2FA"
        @masterFile[nickname]['failsafe'] = false
        authname = ask("\nFirst off; please type your NickServ authname/account name: ") { |q|
                                                                                         q.validate = /\A\w+\Z/
                                                                                       q.responses[:not_valid] = "\nAuthname cannot be blank, please try again!"
                                                                                       q.responses[:ask_on_error] = "\nType your NickServ authname/account name: "
                                                                                       q.confirm = "\nAre you sure you wish to set your authname/account name to <%= @answer %> [yes/no]: "
                                                                                       }
        
        puts "\nSetting authname as #{authname}."
        @masterFile[nickname]['authname'] = authname.to_s.downcase
        begin
          password = ask("\nNext; you need to specify your password: ") {|q| 
                                                                         q.echo = "*"
                                                                        q.validate = /\A\w+\Z/
                                                                        q.responses[:not_valid] = "\nPassword cannot be blank, please try again!"
                                                                        q.responses[:ask_on_error] = "\nPlease specify a password: "
                                                                        }
          
          password2 = ask("Please confirm your password by retyping it: ") {|q| q.echo = "*"}
          
          raise ArgumentError.new("Your passwords do not match, try again!") if password2 != password
        rescue
          puts "#{$!}"
          retry
        end
        
        finalPassword = BCrypt::Password.create(password)
        @masterFile[nickname]['2fa-pass'] = finalPassword
        
        say("\nPlease remember that you must log into NickServ and send the login command with a proper password to the bot in order to use master commands!")
        say("To log into the bot on IRC you can just use the following command preceded by the proper trigger: " +
            "\nlogin <nickname> <password>")
        sleep config[:delay] || 3
      end
      
      def enable_pass(nickname)
        say("\n\nYou've selected password only authentication. This means that you will only need to use a password to identify with the bot!") 
        raise ArgumentError.new("You've indicated that you're not sure that you want to implement password only authentication, returning...") if !agree("Are you sure you want to do this? [yes/no] ")
        
        @masterFile[nickname]['authentication'] = "PASS"
        @masterFile[nickname]['failsafe'] = false
        
        begin
          password = ask("Please create a master password: ") {|q| q.echo = "*"
                                                               q.validate = /\A\w+\Z/
                                                               q.responses[:not_valid] = "\nMaster password cannot be blank, please try again!"
                                                               q.responses[:ask_on_error] = "\nCreate a master password: "
                                                              }
          
          password2 = ask("Please confirm your password by retyping it: ") {|q| q.echo = "*"}
                                                                                                                                                        
          raise ArgumentError.new("Your passwords do not match, try again!") if password2 != password
          
          finalPassword = BCrypt::Password.create(password)
          @masterFile[nickname]['master-pass'] = finalPassword
        rescue
          puts "#{$!}"
          retry
        end
        
        say("\nPlease remember that the only way to log into the bot is by sending the login command with a proper password to the bot!")
        say("To log into the bot on IRC you can use the following command preceded by the proper trigger: \nlogin <nickname> <password>")
        sleep config[:delay] || 3
      end
      
      def enable_ns(nickname)
        say("\n\nYou've selected NickServ authentication meaning that the only way the bot can identify you is if you authenticate with NickServ.")
        raise ArgumentError.new("You've indicated that you're not sure you want to implement password only authentication, returning...") if !agree("Are you sure you want to do this? [yes/no] ")
        
        @masterFile[nickname]['authentication'] = "NS"
        @masterFile[nickname]['failsafe'] = false
        
        authname = ask("\nPlease type your NickServ authname/account name: ") { |q|
                                                                                            q.validate = /\A\w+\Z/
                                                                                            q.responses[:not_valid] = "\nAuthname cannot be blank, please try again!"
                                                                                            q.responses[:ask_on_error] = "\nType your NickServ authname/account name: "
                                                                                            q.confirm = "\nAre you sure you wish to set your authname/account name to <%= @answer %> [yes/no]: "
                                                                                          }
          
        @masterFile[nickname]['authname'] = authname.downcase
        
        say("Please remember that the only way that the bot can authenticate you is if you're logged into NickServ using the authname you've specified!")
        sleep config[:delay] || 3
      end
      
      def enable_nsFS(nickname)
        say("\n\nYou've selected NickServ authentication with a fail-safe password. This means that the bot will primarily identify you by your authname after you've logged into NickServ, if there is a problem with services you can still use your fail-safe password to log in.")
        raise ArgumentError.new("You've indicated that you're not sure you want to implement NickServ authentication with a fail-safe password, returning...") if !agree("Are you sure this is what you want to do? [yes/no] ")
        
        @masterFile[nickname]['authentication'] = "NS"
        @masterFile[nickname]['failsafe'] = true
        
        authname = ask("\nPlease type your NickServ authname/account name: ") { |q|
                                                                                q.validate = /\A\w+\Z/
                                                                                q.responses[:not_valid] = "\nAuthname cannot be blank, please try again!"
                                                                                q.responses[:ask_on_error] = "\nType your NickServ authname/account name: "
                                                                                q.confirm = "\nAre you sure you wish to set your authname/account name to <%= @answer %> [yes/no]: "
                                                                              }
          
        @masterFile[nickname]['authname'] = authname.downcase
        
        begin
        
          password = ask("Please create a fail-safe password: ") {|q| q.echo = "*"
                                                                  q.validate = /\A\w+\Z/
                                                                  q.responses[:not_valid] = "\nFail-safe password cannot be blank, please try again!"
                                                                  q.responses[:ask_on_error] = "\nCreate a fail-safe password: "
                                                                 }
          
          password2 = ask("Please confirm your password: ") {|q| q.echo = "*"}
          raise ArgumentError.new("Your passwords don't match, try again!") if password2 != password
          
          finalPassword = BCrypt::Password.create(password)
          
          @masterFile[nickname]['fsPass'] = finalPassword
        rescue
          puts "#{$!}"
          retry
        end
        
        say("Please remember that in order to ordinarily authenticate with the bot you must sign into NickServ. \nThe fail-safe password is available if needed.")
        sleep config[:delay] || 3
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
          else
            m.user.send "You are not logged into NickServ!"
          end
        end
      end
      
      def timeoutHandler(m, user, option="start")
        if option == "start"
          @timeoutTimer = Timer(30, shots: 1) { logout(m, user, "timeout") }
        else
          @timeoutTimer.stop
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
      
      def update_store
        say("\nWriting master file...")
        begin
          synchronize(:update) do
            File.open('config/settings/masters.yaml', 'w') do |fh|
              YAML.dump(@masterFile, fh)
            end
          end
        rescue
          puts "#{$!}"
          abort("Error creating file: masters.yaml")
        end
        sleep config[:delay] || 3
        say("Master file written!")
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