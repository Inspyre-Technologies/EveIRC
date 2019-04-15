# frozen_string_literal: true

require 'cinch'
require 'ostruct'
require 'open-uri'
require 'json'
require 'yaml'
require 'cinch/toolbox'
require_relative 'config/check_auth'
require_relative 'config/check_ignore'
require_relative 'config/check_master'
require_relative 'helpers/geolookup'

module Cinch
  module Plugins
    class UserInfo
      include Cinch::Plugin
      include Cinch::Helpers

      set :plugin_name, 'userinfo'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
      Save certain data to the bot for convienence and sometimes privacy
      Usage:
      * !set-l <location>: Save your location to the bot for future use in calling weather.
      * !set-greeting <custom-greeting>: Save a custom greeting for the bot to use when you enter the channel.
      * !set-twitter <handle>: Save your Twitter handle to the bot for use with the Twitter plugin! (use !@ to call your own Twitter information!)
      * !set-birthday <YYYY-MM-DD>: Save your birthday to the bot for special surprises!
      There are delete commands as well:
      * !del-l: Delete your location data from the bot.
      * !del-greeting: Deletes your custom greeting from the bot.
      * !del-twitter: Deletes your Twitter handle from the bot.
      * !del-birthday: Deletes your birthday from the bot.
      USAGE

      def initialize(*args)
        super
        @storage = if File.exist?('docs/userinfo.yaml')
                     YAML.load_file('docs/userinfo.yaml')
                   else
                     {}
                   end
      end

      match /set-l (.+)/, method: :set_l

      match /set-twitter (.+)/, method: :set_twitter

      match /set-greeting (.+)/, method: :set_greeting

      match /set-rgreeting (.+?) (.+)/, method: :set_rgreeting

      match /set-birthday ((\d{4})-(0[1-9]|1[012]|[1-9])-([12]\d|3[01]|[1-9]|0[1-9]))/, method: :set_birthday

      match /set-gender (male|female)/, method: :set_gender

      match /set-lastfm (.+)/, method: :set_lastfm

      match /del-w/, method: :del_w

      match /del-twitter/, method: :del_twitter

      match /del-greeting/, method: :del_greeting

      match /del-birthday/, method: :del_birthday

      match /del-data/, method: :del_data

      match /del-lastfm/, method: :del_lastfm

      match /rdel-data (.+)/, method: :rdel_data

      def set_l(m, zc)
        return if check_ignore(m.user)

        location = geolookup(m, zc)

        unless location
          return m.reply 'Please try again using your postal code in place of your town name.'
        end

        coords = location[0]
        name = location[1]

        @storage[User(m.user).nick]['location_data'] ||= {}
        w_user = @storage[User(m.user).nick]['location_data']

        w_user['coords'] = coords.to_s
        w_user['name'] = name

        @storage[m.user.nick]['auth'] = User(m.user).authname

        m.reply "Updated your weather location to: \"#{name}\"!"

        update_store
      end

      def del_l(m)
        return if check_ignore(m.user)

        if @storage.key?(m.user.nick)
          stored_user = @storage[m.user.nick]
          if stored_user.key? 'location_data'
            stored_user.delete('location_data')
            update_store
            m.reply 'Successfully deleted your location data!'
            return
          end
          m.reply 'You have no location data set!'
        end
      end

      def set_twitter(m, handle)
        return if check_ignore(m.user)

        @storage[m.user.nick] ||= {}
        @storage[m.user.nick]['twitter'] = handle
        m.reply "Updated your Twitter handle to #{handle}!"
        update_store
      rescue StandardError
        m.reply Format(:red, "Error: #{$ERROR_INFO}")
      end

      def del_twitter(m)
        return if check_ignore(m.user)

        if @storage.key?(m.user.nick)
          if @storage[m.user.nick].key? 'twitter'
            t = @storage[m.user.nick]
            t.delete('twitter')
            update_store
            m.reply 'Successfully deleted your Twitter handle!'
            return
          end
          m.reply 'You have no Twitter handle set!'
        end
      end

      def set_greeting(m, greeting)
        return if check_ignore(m.user)

        @storage[m.user.nick] ||= {}
        @storage[m.user.nick]['greeting'] = greeting
        m.reply "Updated your custom greeting to \"#{greeting}\"!"
        update_store
      rescue StandardError
        m.reply Format(:red, "Error: #{$ERROR_INFO}")
      end

      def del_greeting(m)
        return if check_ignore(m.user)

        if @storage.key?(m.user.nick)
          if @storage[m.user.nick].key? 'greeting'
            g = @storage[m.user.nick]
            g.delete('greeting')
            update_store
            m.reply 'Successfully deleted your custom greeting!'
            return
          end
          m.reply 'You have no custom greeting set!'
        end
      end

      def set_rgreeting(m, user, greeting)
        return if check_ignore(m.user)
        return unless check_master(m.user)

        @storage[user] ||= {}
        @storage[user]['greeting'] = greeting
        m.reply "Updated #{user}'s greeting to \"#{greeting}\"."
        update_store
      rescue StandardError
        m.reply Format(:red, "Error: #{$ERROR_INFO}")
      end

      def set_birthday(m, birthday)
        return if check_ignore(m.user)

        @storage[m.user.nick] ||= {}
        @storage[m.user.nick]['birthday'] = birthday
        m.reply "Updated your birthday to \"#{birthday}\"."
        update_store
      rescue StandardError
        m.reply Format(:red, "Error: #{$ERROR_INFO}")
      end

      def del_birthday(m)
        return if check_ignore(m.user)

        if @storage.key?(m.user.nick)
          if @storage[m.user.nick].key? 'birthday'
            b = @storage[m.user.nick]
            b.delete('birthday')
            update_store
            m.reply 'Successfully deleted your birthday data!'
            return
          end
          m.reply 'You have no birthday data set!'
        end
      end

      def del_data(m)
        return if check_ignore(m.user)

        if @storage.key?(m.user.nick)
          @storage.delete m.user.nick
          update_store
          m.reply 'All of your custom data has been deleted!'
          return
        end
        m.reply 'You have no custom data set!'
      end

      def rdel_data(m, user)
        return if check_ignore(m.user)

        unless check_user(m.user)
          m.reply Format(:red, 'You are not authorized to use that command!')
          return
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
      rescue StandardError
        m.reply Format(:red, "Error: #{$ERROR_INFO}")
      end

      # Added LastFM username storage for the LastFM plugin (lastfm.rb) to use

      def set_lastfm(m, username)
        return if check_ignore(m.user)

        @storage[m.user.nick] ||= {}
        @storage[m.user.nick]['lastfm'] = username
        update_store
        m.reply "Updated your LastFM username to #{username}!"
      rescue StandardError
        m.reply Format(:red, "Error: #{$ERROR_INFO}")
      end

      # Added delete function for LastFM information

      def del_lastfm(m)
        return if check_ignore(m.user)

        if @storage.key?(m.user.nick)
          if @storage[m.user.nick].key? 'lastfm'
            l = @storage[m.user.nick]
            l.delete('lastfm')
            update_store
            m.reply 'Successfully deleted your LastFM information!'
            return
          end
          m.reply "You don't have that value set!"
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
end
