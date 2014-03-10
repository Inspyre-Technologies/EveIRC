require 'cinch'
require 'yaml'

module Cinch
  module Helpers
      
    def check_foe(user)
      reload
      if ((@storage.key?(user.nick)) && (@storage[user.nick].key? 'foe'))
        foe = @storage[user.nick]['foe']
        return foe
      end
    end
    
    def reload
      if File.exist?('docs/userinfo.yaml')
       @storage = YAML.load_file('docs/userinfo.yaml')
      else
        @storage = {}
      end
    end
  end
end