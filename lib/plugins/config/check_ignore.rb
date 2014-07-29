require 'cinch'
require 'yaml'

module Cinch
  module Helpers
      
    def check_ignore(user)
      reload
      if ((@storage.key?(user.nick)) && (@storage[user.nick].key? 'ignore'))
        ignore = @storage[user.nick]['ignore']
        return ignore
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
