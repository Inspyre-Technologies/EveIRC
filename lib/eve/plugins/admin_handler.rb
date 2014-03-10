require 'cinch'
require_relative "config/check_master"

module Cinch::Plugins
  class AdminHandler
    include Cinch::Plugin
    include Cinch::Helpers
    
    def initialize(*args)
      super
        if File.exist?('docs/userinfo.yaml')
          @storage = YAML.load_file('docs/userinfo.yaml')
        else
          @storage = {}
        end
      end
      
    match /add-master (.+)/, method: :set_master
      
    match /del-master (.+)/, method: :del_master
      
    def set_master(m, target)
      unless check_master(m.user)
        m.reply Format(:red, "You are not authorized to use that command!")
      return;
    end
      mas = User(target)
      sleep config[:delay] || 4
      mas.refresh
      auth = mas.authname
      @storage[User(target).nick] ||= {}
      @storage[User(target).nick]['auth'] = auth
      @storage[User(target).nick]['master'] = true
      update_store
      m.reply "Added #{User(target).nick} as a master!"
    end
    
   def del_master(m, target)
     unless check_master(m.user)
       m.reply Format(:red, "You are not authorized to use that command!")
     return;
   end
     if @storage.key?(User(target).nick)
       if @storage[User(target).nick].key? 'master'
         mas = @storage[User(target).nick]
         mas.delete('master')
         update_store
         m.reply "Deleted #{User(target).nick} from the masters list"
        else
          m.reply "#{User(target).nick} isn't a master!"
        end
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

      
      