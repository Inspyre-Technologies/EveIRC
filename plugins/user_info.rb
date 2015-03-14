require 'cinch'
require 'yaml'
require_relative '../lib/helpers/determine_master'
require_relative '../lib/helpers/geolocation'
require_relative '../lib/helpers/logger'

module Cinch
  module Plugins
    class UserInfo
      include Cinch::Plugin
      include Cinch::Helpers
      
      set :prefix, eval(YAML.load_file('config/settings/settings.yaml')['prefix'])
      
      def initialize(*args)
        super
        if File.exist?('config/settings/user_info.yaml')
          if !File.zero?('config/settings/user_info.yaml')
            log_message("message", "Found user_info.yaml and it is not empty. Proceeding...", PluginName)
            log_message("message", "Loading contents of user_info.yaml into array...", PluginName)
            @userSettings = YAML.load_file('config/settings/user_info.yaml')
            log_message("message", "Array successfully constructed!", PluginName)
          else
            log_message("warn", "user_info.yaml is empty. Starting UserInfo first-run wizard...", PluginName)
            load 'lib/utils/ui_first_run.rb'
            UIFirstRun.new(*args)
          end
        else
          log_message("warn", "user_info.yaml doesn't exist. Starting UserInfo first-run wizard...", PluginName)
          log_message("warn", "user_info.yaml either doesn't exist or is empty. Starting UserInfo first-run wizard...", PluginName)
          load 'lib/utils/ui_first_run.rb'
          UIFirstRun.new(*args)
        end
      end
      
      def determine_name(m)
        irc_nick = User(m.user).nick
        if @userSettings.key?(irc_nick.downcase) 
          if @userSettings[irc_nick.downcase].key?('irl_name')
            if @userSettings[irc_nick.downcase]['irl_name'] != false
              irl_nick = @userSettings[irc_nick.downcase]['irl_name']
              nick_array = ["#{irl_nick}", "#{irc_nick}"]
              return nick_array.sample
            else
              return irc_nick
            end
          else
            return irc_nick
          end
        else
          return irc_nick
        end
      end
      
      def check_plugin(m, plugin)
        log_message("message", "Checking to see if the #{plugin} plugin is loaded...", PluginName)
        if @bot.plugins.include?(plugin)
          log_message("message", "#{plugin} plugin is loaded. Proceeding...", PluginName)
          @loaded = true
        else
          log_message("warn", "#{plugin} plugin is not loaded. Advising user...")
          determine_master
          m.reply "#{User(m.user).nick}, the #{plugin} plugin is not loaded! Please contact #{@master_nick} if you wish to have it loaded, #{@master_pronoun}'s my master!"
          @loaded = false
        end
      end
      
      def set_settings(m, key, value)
        if @userSettings.key?(User(m.user).nick.downcase)
          @userSettings[User(m.user).nick.downcase][key] = value
          return true
        else
          @userSettings[User(m.user).nick.downcase] ||= {}
          @userSettings[User(m.user).nick.downcase][key] = value
          return true
        end
      end
      
      match /set (.+?) (.+)/i, method: :set
      
      def set(m, key, value)
        acceptable_keys = ["twitter", "lastfm", "gender", "location", "birthdate", "greeting", "name"]
        if acceptable_keys.include?(key.downcase)
          key   = key.downcase
          value = value.downcase unless key == "greeting" or "name"
          case key
            
          when "twitter"
            set_twitter(m, value)
            
          when "lastfm"
            set_lastfm(m, value)
            
          when "gender"
            set_gender(m, value)
            
          when "location"
            set_location(m, value)
            
          when "birthdate"
            set_birthdate(m, value)
            
          when "greeting"
            set_greeting(m, value)
            
          when "name"
            set_name(m, value)
            
          end
          update_settings
        else
          acceptable_keys = acceptable_keys.join(", ")
          m.reply "#{determine_name(m)}, #{key} is not a valid key. Try one of these: #{acceptable_keys}"
        end
      end
      
      def set_twitter(m, value)
        if check_plugin(m, "Twitter")
          set_settings(m, 'twitter_handle', value)
          m.reply "#{determine_name(m)}, I've set your Twitter handle as #{value}!"
        end
      end
      
      def set_lastfm(m, value)
        if check_plugin(m, "LastFM")
          set_settings(m, 'lfm_username', value)
          m.reply "#{determine_name(m)}, I've set your LastFM username as #{value}!"
        end
      end
      
      def set_gender(m, value)
        if ["male", "female"].include?(value)
          set_settings(m, 'gender', value)
          m.reply "#{determine_name(m)}, I've set your gender to #{value}!"
        else
          m.reply "#{determine_name(m)}, #{value} is not a valid gender input. Please use 'male', or 'female'!"
        end
      end
      
      def set_location(m, value)
        if geolocation(value)
          m.reply "#{determine_name(m)}, I've found the closest match to your location: #{@address} | Coordinates: #{@lat},#{@lng}"
          set_settings(m, 'address', @address)
          set_settings(m, 'coordinates', "#{@lat},#{@lng}")
          m.reply "#{determine_name(m)}, I've set your location data!"
        else
          m.reply "#{determine_name(m)}, I couldn't find your location, please try again!"
        end
      end
      
      def set_birthdate(m, value)
        now = Date.today
        dob = Date.parse(value)
        age = now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
        m.reply "#{determine_name(m)}, according to your birthdate input you are #{age} years old!"
        set_settings(m, 'birthdate', dob.to_s)
        m.reply "#{determine_name(m)}, I've set your birthdate in my records!"
      end
      
      def set_greeting(m, value)
        set_settings(m, 'greeting', value)
        m.reply "#{determine_name(m)}, your greeting has been set to: \"#{value}\"!"
      end
      
      def set_name(m, value)
        set_settings(m, 'irl_name', value)
        m.reply "#{determine_name(m)}, your name has been set to: \"#{value}\"!"
      end
      
      def update_settings
        synchronize(:update) do
          File.open('config/settings/user_info.yaml', 'w') do |fh|
            YAML.dump(@userSettings, fh)
          end
        end
      end
    end
  end
end
            
