require 'cinch'
require 'ostruct'
require 'open-uri'
require 'json'
require 'yaml'
require 'cinch/toolbox'
require_relative "config/check_auth"
require_relative "config/check_ignore"
require_relative "config/check_master"

module Cinch
  module Plugins
    class UserInfo
      include Cinch::Plugin
      include Cinch::Helpers

      set :plugin_name, 'userinfo'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
      Save certain data to the bot for convienence and sometimes privacy
      Usage:
      * !set-w <location>: Save your location to the bot for future use in calling weather.
      * !set-greeting <custom-greeting>: Save a custom greeting for the bot to use when you enter the channel.
      * !set-twitter <handle>: Save your Twitter handle to the bot for use with the Twitter plugin! (use !@ to call your own Twitter information!)
      * !set-birthday <YYYY-MM-DD>: Save your birthday to the bot for special surprises!
      There are delete commands as well:
      * !del-w: Delete your location data from the bot.
      * !del-greeting: Deletes your custom greeting from the bot.
      * !del-twitter: Deletes your Twitter handle from the bot.
      * !del-birthday: Deletes your birthday from the bot.
      USAGE

      def initialize(*args)
        super
        if File.exist?('docs/userinfo.yaml')
          @storage = YAML.load_file('docs/userinfo.yaml')
        else
          @storage = {}
        end
      end

      match /set-w (.+)/, method: :set_w

      match /set-twitter (.+)/, method: :set_twitter

      match /set-greeting (.+)/, method: :set_greeting

      match /set-rgreeting (.+?) (.+)/, method: :set_rgreeting

      match /set-birthday ((\d{4})-(0[1-9]|1[012]|[1-9])-([12]\d|3[01]|[1-9]|0[1-9]))/, method: :set_birthday

      match /set-gender (male|female)/, method: :set_gender


      match /del-w/, method: :del_w

      match /del-twitter/, method: :del_twitter

      match /del-greeting/, method: :del_greeting

      match /del-birthday/, method: :del_birthday

      match /del-data/, method: :del_data

      match /rdel-data (.+)/, method: :rdel_data


      def set_w(m, zc)
        return if check_ignore(m.user)
        zc.gsub! /\s/, '+'

        geoData = JSON.parse(open("http://maps.googleapis.com/maps/api/geocode/json?address=#{zc}&sensor=true").read)

        location = geoData['results'][0]['geometry']['location']
        lat = location['lat']
        lng = location['lng']
        fAddress = geoData['results'][0]['formatted_address']

        @storage[User(m.user).nick] ||= {}
        @storage[m.user.nick]['wLocation'] = "#{lat},#{lng}"
        @storage[m.user.nick]['wAddress'] = fAddress
        @storage[m.user.nick]['auth'] = User(m.user).authname
        m.reply "Updated your weather location to: \"#{fAddress}\"!"
        update_store
      rescue
        m.reply Format(:red, "Error: #{$!}")
      end

      def del_w(m)
        return if check_ignore(m.user)
        if @storage.key?(m.user.nick)
          if @storage[m.user.nick].key? 'wLocation'
            w = @storage[m.user.nick]
            w.delete('wLocation')
            w.delete('wAddress')
            update_store
            m.reply "Successfully deleted your location data!"
            return;
          end
          m.reply "You have no location data set!"
        end
      end

      def set_twitter(m, handle)
        return if check_ignore(m.user)
        @storage[m.user.nick] ||= {}
        @storage[m.user.nick]['twitter'] = handle
        m.reply "Updated your Twitter handle to #{handle}!"
        update_store
      rescue
        m.reply Format(:red, "Error: #{$!}")
      end

      def del_twitter(m)
        return if check_ignore(m.user)
        if @storage.key?(m.user.nick)
          if @storage[m.user.nick].key? 'twitter'
            t = @storage[m.user.nick]
            t.delete('twitter')
            update_store
            m.reply "Successfully deleted your Twitter handle!"
            return;
          end
          m.reply "You have no Twitter handle set!"
        end
      end

      def set_greeting(m, greeting)
        return if check_ignore(m.user)
        @storage[m.user.nick] ||= {}
        @storage[m.user.nick]['greeting'] = greeting
        m.reply "Updated your custom greeting to \"#{greeting}\"!"
        update_store
      rescue
        m.reply Format(:red, "Error: #{$!}")
      end

      def del_greeting(m)
        return if check_ignore(m.user)
        if @storage.key?(m.user.nick)
          if @storage[m.user.nick].key? 'greeting'
            g = @storage[m.user.nick]
            g.delete('greeting')
            update_store
            m.reply "Successfully deleted your custom greeting!"
            return;
          end
          m.reply "You have no custom greeting set!"
        end
      end

      def set_rgreeting(m, user, greeting)
        return if check_ignore(m.user)
        return unless check_master(m.user)
        @storage[user] ||= {}
        @storage[user]['greeting'] = greeting
        m.reply "Updated #{user}'s greeting to \"#{greeting}\"."
        update_store
      rescue
        m.reply Format(:red, "Error: #{$!}")
      end

      def set_birthday(m, birthday)
        return if check_ignore(m.user)
        @storage[m.user.nick] ||= {}
        @storage[m.user.nick]['birthday'] = birthday
        m.reply "Updated your birthday to \"#{birthday}\"."
        update_store
      rescue
        m.reply Format(:red, "Error: #{$!}")
      end

      def del_birthday(m)
        return if check_ignore(m.user)
        if @storage.key?(m.user.nick)
          if @storage[m.user.nick].key? 'birthday'
            b = @storage[m.user.nick]
            b.delete('birthday')
            update_store
            m.reply "Successfully deleted your birthday data!"
            return;
          end
          m.reply "You have no birthday data set!"
        end
      end

      def del_data(m)
        return if check_ignore(m.user)
        if @storage.key?(m.user.nick)
          @storage.delete m.user.nick
          update_store
          m.reply "All of your custom data has been deleted!"
          return;
        end
        m.reply "You have no custom data set!"
      end

      def rdel_data(m, user)
        return if check_ignore(m.user)
        unless check_user(m.user)
          m.reply Format(:red, "You are not authorized to use that command!")
          return;
        end
        if @storage.key?(user)
          @storage.delete user
          update_store
          m.reply "All of #{user}'s data has been deleted!"
        else
          m.reply "#{user} has no custom data set!"
        end
      end

      def set_gender(m, gender)
        return if check_ignore(m.user)
        @storage[m.user.nick] ||= {}
        @storage[m.user.nick]['gender'] = gender
        update_store
        m.reply "Updated your gender to #{gender}!"
      rescue
        m.reply Format(:red, "Error: #{$!}")
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
