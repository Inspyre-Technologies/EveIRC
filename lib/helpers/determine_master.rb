require 'cinch'
require 'yaml'

module Cinch
  module Helpers
    
    PluginName = "Helper - DetermineMaster"
    
    def determine_master
      log_message("message", "Checking to see if masters.yaml exists...", PluginName)
      if File.exist?('config/settings/masters.yaml')
        log_message("message", "masters.yaml exists! Proceeding...", PluginName)
        log_message("message", "checking to see if masters.yaml is empty...", PluginName)
        if !File.zero?('config/settings/masters.yaml')
          log_message("message", "masters.yaml is not empty! Proceeding...", PluginName)
          log_message("message", "Loading masters.yaml into an array...", PluginName)
          @mastersFile = YAML.load_file('config/settings/masters.yaml')
          log_message("message", "File loaded into array!", PluginName)
          log_message("message", "Finding master nick...", PluginName)
          @master_nick = @mastersFile.keys[0]
          log_message("message", "Found master nick; #{@master_nick}!", PluginName)
          log_message("message", "Checking master's gender...", PluginName)
          log_message("message", "Checking to see if user_info.yaml exists...", PluginName)
          if File.exist?('config/settings/user_info.yaml')
            log_message("message", "user_info.yaml exists! Proceeding...", PluginName)
            log_message("message", "Checking to see if user_info.yaml is empty...", PluginName)
            if !File.zero?('config/settings/user_info.yaml')
              log_message("message", "user_info.yaml is not empty! Proceeding...", PluginName)
              
              log_message("message", "Loading user_info.yaml into an array...", PluginName)
              @masterSettings = YAML.load_file('config/settings/user_info.yaml')
              log_message("message", "File loaded into array!", PluginName)
              
              log_message("message", "Finding #{@master_nick}'s gender...", PluginName)
              @master_gender = @masterSettings[@master_nick.downcase]['gender']
              
              case @master_gender
              
              when "male"
                @master_pronoun     = "he"
                @master_possesive   = "his"
                @master_self        = "himself"
                @master_descriptive = "him"
              
              when "female"
                @master_pronoun     = "she"
                @master_possesive   = "hers"
                @master_self        = "herself"
                @master_descriptive = "her"
                
              when "false"
                @master_pronoun     = "they"
                @master_possesive   = "theirs"
                @master_self        = "themselves"
                @master_descriptive = "them"
              end
            else
              log_message("warn", "user_info.yaml is empty. Setting #{@master_nick}'s gender as false.", PluginName)
              @master_gender = false
            end
          else
            log_message("warn", "user_info.yaml doesn't exist. Setting #{@master_nick}'s gender as false.", PluginName)
            @master_gender = false
          end
        else
          log_message("error", "masters.yaml is empty.", PluginName)
          abort("This is a fatal error, masters.yaml is empty. Attempt to run restore option.")
        end
      else
        log_message("error", "masters.yaml doesn't exist.", PluginName)
        abort("This is a fatal error, masters.yaml doesn't exist. Attempt to run restore option.")
      end
    end
  end
end