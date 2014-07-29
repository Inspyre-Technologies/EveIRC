require 'cinch'
require_relative "config/check_master"
require_relative "config/check_friend"
require_relative "config/check_foe"

module Cinch
  module Plugins
    class RelationshipHandler
      include Cinch::Plugin
      
      set :plugin_name, 'relationshiphandler'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
        Allows you to control the basic functions of the bot.
        Usage:
        - !add-friend <user>: Adds <user> as a 'friend' of the bot.
        - !add-foe <user>: Adds <user> as a 'foe' of the bot.
        - !del-relationship <user>: Deletes <user>'s relationship information from the bot.
        USAGE

      def initialize(*args)
        super
          if File.exist?('docs/userinfo.yaml')
            @storage = YAML.load_file('docs/userinfo.yaml')
          else
            @storage = {}
          end
        end
        
      def reload
        if File.exist?('docs/userinfo.yaml')
          @storage = YAML.load_file('docs/userinfo.yaml')
        else
          @storage = {}
      end
    end
        
        match /add-friend (.+)/, method: :add_friend
        
        match /add-foe (.+)/, method: :add_foe
        
        match /del-relationship (.+)/, method: :del_relationship
        
      def add_friend(m, target)
        unless check_master(m.user)
          m.user.notice Format(:red, "You are not authorized to use this command! This incident will be reported.")
          Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'add-friend' command to add #{target} but was not authorized.") }
        return;
      end
        @storage[User(target).nick] ||= {}
        @storage[User(target).nick]['friend'] = true
        store = @storage[User(target).nick]
        store.delete('foe')
        update_store
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} used the 'add-friend' command to add #{target}.") }
        m.reply "Added friend."
      end
        
        def add_foe(m, target)
          unless check_master(m.user)
            m.user.notice Format(:red, "You are not authorized to use this command! This incident will be reported.")
            Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'add-foe' command to add #{target} but was not authorized.") }
          return;
        end
          @storage[User(target).nick] ||= {}
          @storage[User(target).nick]['foe'] = true
          store = @storage[User(target).nick]
          store.delete('friend')
          update_store
          Config.dispatch.each { |n| User(n).notice("#{m.user.nick} used the 'add-foe' command to add #{target}.") }
          m.reply "Added foe."
        end
        
        def del_relationship(m, target)
          unless check_master(m.user)
            m.user.notice Format(:red, "You are not authorized to use this command! This incident will be reported.")
            Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'del-relationship' command to delete #{target}'s info but was not authorized.") }
          return;
        end
          if @storage.key?(User(target).nick)
            store = @storage[User(target).nick]
            store.delete('friend')
            store.delete('foe')
            update_store
            Config.dispatch.each { |n| User(n).notice("#{m.user.nick} used the 'del-relationship' command to delete #{target}'s info.") }
            m.reply "Removed relationship settings for #{target}."
          else
            m.reply "I have no record of #{target}."
          end
        end
      
        def update_store
          synchronize(:update) do
          File.open('docs/userinfo.yaml', 'w') do |fh|
          YAML.dump(@storage, fh)
        end    
      end
    end
  end
end
end