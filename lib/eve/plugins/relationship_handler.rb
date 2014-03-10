require 'cinch'
require_relative "config/check_master"
require_relative "config/check_friend"
require_relative "config/check_foe"

module Cinch::Plugins
  class RelationshipHandler
    include Cinch::Plugin

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
        m.reply Format(:red, "You are not authorized to use that command!")
      return;
    end
      @storage[User(target).nick] ||= {}
      @storage[User(target).nick]['friend'] = true
      store = @storage[User(target).nick]
      store.delete('foe')
      update_store
      m.reply "Added friend."
    end
      
      def add_foe(m, target)
        unless check_master(m.user)
          m.reply Format(:red, "You are not authorized to use that command!")
        return;
      end
        @storage[User(target).nick] ||= {}
        @storage[User(target).nick]['foe'] = true
        store = @storage[User(target).nick]
        store.delete('friend')
        update_store
        m.reply "Added foe."
      end
      
      def del_relationship(m, target)
        unless check_master(m.user)
          m.reply Format(:red, "You are not authorized to use that command!")
        return;
      end
        if @storage.key?(User(target).nick)
          store = @storage[User(target).nick]
          store.delete('friend')
          store.delete('foe')
          update_store
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