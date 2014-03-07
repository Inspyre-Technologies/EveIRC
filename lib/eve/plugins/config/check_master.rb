require 'yaml'

module Cinch
  module Helpers
  
    def initialize(*args)
      super
        if File.exist?('userinfo.yaml')
          @storage = YAML.load_file('userinfo.yaml')
        else
          @storage = {}
        end
      end
    
    def check_master(user)
      user.refresh
      
      return false unless !user.authname.nil?
      
      if ((@storage.key?(user.nick)) && (@storage[user.nick].key? 'master') && (@storage[user.nick].key? 'auth'))
        mcheck = @storage[user.nick]['master']
        mauth = @storage[user.nick]['auth']
        return ((mauth == user.authname) && mcheck)
      end
    end
  end
end