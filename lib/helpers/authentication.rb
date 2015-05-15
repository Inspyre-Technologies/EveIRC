require 'yaml'
require_relative 'file_handler'

module Cinch
  module Helpers

    def authentication(m)
      query = User(m.user).nick.downcase
      if $admin_file.key?(User(m.user).nick.downcase)
        if $admin_file[query].key?('authname')
          if $admin_file[query].key?('currently')
            if $admin_file[query]['currently'] == "false"
              if $admin_file[query]['authname'] != User(m.user).authname.downcase
                return false
              else
                m.reply "You weren't logged in, logging you in..."
                $admin_file[query]['currently'] = "true"
                write_admin_file
                return true
              end
            else
              return true
            end
          else
            m.reply "You don't seem to have a valid entry in my master file."
            return false
          end
        else
          m.reply "You don't seem to have a valid entry in my master file."
          return false
        end
      else
        m.reply "You are not entered as a master of the bot."
        return false
      end
    end
  end
end