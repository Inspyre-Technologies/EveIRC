# -*- coding: utf-8 -*-
require 'cinch'
require 'cinch/toolbox'
require 'yaml'
require 'time-lord'
require_relative "config/check_ignore"

module Cinch
  module Plugins
    class Seen
      include Cinch::Plugin

      Activity = Struct.new(:nick, :time, :message, :channel)

      listen_to :channel

      set :plugin_name, 'seen'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
      Allows you to control the basic functions of the bot.
      Usage:
      * !seen <user>: The bot searches for the last time <user> spoke and returns with the results.
      USAGE

     # Upon this plugin file loading it will
     # check if the appropriate files exist.
     # If they do not exist it will then create
     # the necessary files.

      def initialize(*args)
        super
        if File.exist?('docs/seen.yaml')
          @storage = YAML.load_file('docs/seen.yaml')
        else
          @storage = {}
        end
      end

      # Below, Cinch uses match to catch commands.

      match /seen (.+)/i

      # The listen block below logs the last thing
      # any user said. This is stored in a YAML
      # db which is written every time a user
      # speaks via the update_store block.

      def listen(m)
        nick = m.user.nick
        channel = m.channel.name
        @storage[nick.downcase] ||= {}
        @storage[nick.downcase]['seen'] =
            Activity.new(nick, Time.now, m.message, channel)
        update_store
      end

      # Upon receiving the !seen query command
      # the below block will execute a search
      # of the YAML database for the query's
      # nick.

      def execute(m, nick)
        # Stripping the end of the query string
        # so that we may search a case sensitive
        # database
        nick   = nick.strip
        
        # Creating variable to hold a downcased 
        # version of the query string.
        nickDown = nick.downcase
        
        # Return if the command if received in
        # a private message. 
        
        return if pm(m)

        # If the user is searching themselves,
        # return.

        return m.reply "Silly #{m.user.nick}, that's you!" if nickDown == m.user.nick.downcase
        
        # Return if the target of the query
        # matches the bot's nick.

        return m.reply "#{m.user.nick} I'm right here! Silly!" if nickDown == bot.nick
        
        # Pass query to seen block

        m.reply seen(m, nick, nickDown), true
      end

      private

      def seen(m, nick, nickDown)
        @storage[nickDown] ||= {}
        seen = @storage[nickDown]['seen']

        if seen.nil?
          "I have no record of seeing #{nick} before!"
        else
          "I last saw #{seen.nick} #{seen.time.ago.to_words} " +
              "saying '#{seen.message}' in #{seen.channel}"
        end
      end

      def pm(m)
        return false unless m.channel.nil?
        m.reply 'You must use that command in the main channel.'
        true
      end

      def update_store
        synchronize(:update) do
          File.open('docs/seen.yaml', 'w') do |fh|
            YAML.dump(@storage, fh)
          end

          def reload
            if File.exist?('docs/seen.yaml')
              @storage = YAML.load_file('docs/seen.yaml')
            else
              @storage = {}
            end
          end
        end
      end
    end
  end
end

## Written by Taylor Blackstone for EveIRC - An Inspyre Technologies Project
## E-mail: taylor@inspyre.tech
## Github: tayjaybabee
## Website: http://inspyre.tech
## IRC: irc.sinsira.net #Eve
