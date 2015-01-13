require 'yaml'
require 'bcrypt'

module Cinch
  module Plugins
    class AdminHandler
      include Cinch::Plugin
      
      def initialize(*args)
        super
        if File.exist?('config/settings/masters.yaml')
          @masterFile = YAML.load_file('config/settings/masters.yaml')
        else
          @masterFile = {}
          puts "Hello, I am Eve. We are now going to run a first-run configuration, are you ready? [y/n]"
          
          answer = gets
          answer = answer.chomp
          answer = answer.downcase
          if answer != "y"
            abort("Thank you for using Eve. Come back when you're ready")
          end
          begin
            puts "First off, tell me what nickname you use on IRC."
            nickname = gets
            nickname = nickname.chomp
            if nickname.empty?
              raise ArgumentError.new('Silly, I need your IRC nickname!')
            end
            @masterFile[nickname] ||= {}
            puts "Excellent! Thank you #{nickname}!"
          rescue
            puts "You need to put in an IRC nickname, silly!"
            retry
          end
          
          begin
            puts "Now it's time to set a password. Please enter one now"
            password = gets
            password = password.chomp
            
            password = BCrypt::Password.create(password)
            
            @masterFile[nickname]['password'] = password
            
            nick = @masterFile[nickname]
            pass = @masterFile[nickname]['password']
            puts "Excellent! Thank you #{nickname}! Your password has been set!"
            puts "Saving file..."
            sleep config[:delay] || 3
            File.new('config/settings/masters.yaml', 'w')
            update_store
            puts "Saved! Starting bot!"
            sleep config[:delay] || 3
          rescue
            puts "You can't have a blank password, silly!"
            retry
          end
        end
      end
      
      match /status/i, method: :status
      
      def status(m)
        m.user.send "Hello #{m.user.nick}!"
        return m.user.send "You are not an admin of the bot" if !@masterFile.key? User(m.user).nick
        return m.user.send "You are admin of the bot, however, you have no password set. !setpass <password> will set your password." if !@masterFile[User(m.user).nick].key? 'password'
        if @masterFile[User(m.user).nick].key? 'logged in'
          if @masterFile[User(m.user).nick]['logged in'] == true
            m.user.send "You are currently logged into the bot."
          else
            m.user.send "You are not currently logged into the bot."
          end
        else
          m.user.send "You are not currently logged into the bot."
        end
      end
      
      match /login (.+?) (.+)/i, method: :login
      
      def login(m, user, pass)
        m.user.send "Attempting login..."
        user = User(user).nick
        if @masterFile.key? User(user).nick
          if @masterFile[User(user).nick].key? 'password'
            stored = @masterFile[User(user).nick]['password']
            sPass  = BCrypt::Password.new(stored)
            if sPass == pass
              @masterFile[User(user).nick]['logged in'] = true
              update_store
              timeoutHandler(m, user)
              m.user.send "You have successfully logged in."
            else
              m.user.send "Either the specified password is incorrect or the user doesn't exist!"
            end
          else
            m.user.send "You do not have a password specified. !setpass <password> will set your password."
          end
        else
          m.user.send "The specified user does not exist in my database!"
        end
      end
      
      def timeoutHandler(m, user)
        Timer(30, shots: 1) { logout(m, user, "timeout") } 
      end
      
      match /logout (.+)/i, method: :logout
      
      def logout(m, user, reason="user defined")
        if reason == "user defined"
          @masterFile[User(user).nick]['logged in'] = false
          m.user.send "You have been logged out of the bot!"
          update_store
        else
          m.user.send "Your session has timed out. Please log back in when you're ready!"
          @masterFile[User(user).nick]['logged in'] = false
          update_store
        end
      end
      
      def update_store
        synchronize(:update) do
          File.open('config/settings/masters.yaml', 'w') do |fh|
            YAML.dump(@masterFile, fh)
          end
        end
      end
    end
  end
end