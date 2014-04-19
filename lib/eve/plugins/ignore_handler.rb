require "cinch"
require_relative "config/check_master"

module Cinch
  module Plugins
    class IgnoreHandler
      include Cinch::Plugin
      
      set :plugin_name, 'ignorehandler'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
        Allows you to control the basic functions of the bot.
        Usage:
        - !add-ignore <user>: Adds <user> to the ignore list of the bot
        - !del-ignore <user>: Removes <user> from the ignore list of the bot
        USAGE
        
      def initialize(*args)
        super
          if File.exist?('docs/ignorelist.yaml')
            @storage = YAML.load_file('docs/ignorelist.yaml')
          else
            @storage = {}
          end
        end
        
      def reload
        if File.exist?('docs/userinfo.yaml')
          @storage = YAML.load_file('docs/ignorelist.yaml')
        else
          @storage = {}
      end
    end
    
    match /add-ignore (.+)/, method: :add_ignore
    match /del-ignore (.+)/, method: :del_ignore
    
    def add_ignore(m, target)
        unless check_master(m.user)
          m.user.notice Format(:red, "You are not authorized to use this command! This incident will be reported.")
          Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'add-ignore' command to add #{target} but was not authorized.") }
        return;
      end
        @storage[User(target).nick] ||= {}
        @storage[User(target).nick]['ignore'] = true
        store = @storage[User(target).nick]
        update_store
        Config.dispatch.each { |n| User(n).notice("#{m.user.nick} used the 'add-ignore' command to add #{target}.") }
        m.reply "#{target} added to ignore list."
      end
      
    def del_ignore(m, target)
          unless check_master(m.user)
            m.user.notice Format(:red, "You are not authorized to use this command! This incident will be reported.")
            Config.dispatch.each { |n| User(n).notice("#{m.user.nick} attempted to use the 'del-ignore' command to remove #{target}'s ignore but was not authorized.") }
          return;
        end
          if @storage.key?(User(target).nick)
            store = @storage[User(target).nick]
            store.delete('ignore')
            update_store
            Config.dispatch.each { |n| User(n).notice("#{m.user.nick} used the 'del-ignore' command to delete #{target}'s info.") }
            m.reply "Removed ignore on #{target}."
          else
            m.reply "#{target} is not on my ignore list!"
          end
        end
        
      def update_store
          synchronize(:update) do
          File.open('docs/ignorelist.yaml', 'w') do |fh|
          YAML.dump(@storage, fh)
        end
      end
    end
  end
end
end
