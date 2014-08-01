# coding: utf-8

require "oj"
require "twitter"
require "cgi"
require "time-lord"
require "yaml"
require_relative "config/check_ignore"

module Cinch
  module Plugins
    class Twitter
      include Cinch::Plugin

      def initialize(*args)
        super
        @client = twitter_client
      end

      match /tw (\w+)(?:-(\d+))?$/, method: :execute_tweet
      match /(\w+)(?:-(\d+))?$/, method: :execute_tweet, prefix: /^@/

      match /@(?:-(\d+))?$/, method: :execute_ctweet, prefix: /^~/

      def execute_tweet(m, username, offset)
        return if check_ignore(m.user)
        offset ||= 0

        user = @client.user(username)

        return m.reply "This user's tweets are protected!" if user.protected?
        return m.reply "This user hasn't tweeted yet!" if user.status.nil?

        if offset.to_i > 0
          tweets = @client.user_timeline(user)
          return m.reply "You can not backtrack more than #{tweets.count.pred} tweets before the current tweet!" if offset.to_i > tweets.count.pred
          tweet = tweets[offset.to_i]

        else
          tweet = user.status
        end
        m.reply format_tweet(tweet)
      rescue ::Twitter::Error::NotFound => e
        m.reply "#{username} doesn't exist."
      rescue ::Twitter::Error => e
        m.reply "#{e.message.gsub(/user/i, username)}. (#{e.class})"
      end

      match /t-search (.+)/, method: :execute_search, prefix: /^~/

      def execute_search(m, term)
        return if check_ignore(m.user)
        @client.search("#{term}", :result_type => "recent").take(3).each do |tweet|
          m.reply format_tweet(tweet)
        end
      end

      def execute_ctweet(m, offset)
        return if check_ignore(m.user)
        loadfile
        offset ||= 0

        if @storage.key?(m.user.nick)
          if @storage[m.user.nick].key? 'twitter'

            username = @storage[m.user.nick]['twitter']

            user = @client.user(username)
          end
          return m.reply Format(:red, "No custom data set") if @storage[m.user.nick]['twitter'].nil?
        end

        return m.reply "This user's tweets are protected!" if user.protected?
        return m.reply "This user hasn't tweeted yet!" if user.status.nil?

        if offset.to_i > 0
          tweets = @client.user_timeline(user)
          return m.reply "You can not backtrack more than #{tweets.count.pred} tweets before the current tweet!" if offset.to_i > tweets.count.pred
          tweet = tweets[offset.to_i]

        else
          tweet = user.status
        end
        m.reply format_tweet(tweet)
      rescue ::Twitter::Error::NotFound => e
        m.reply "#{username} doesn't exist."
      rescue ::Twitter::Error => e
        m.reply "#{e.message.gsub(/user/i, username)}. (#{e.class})"
      end

      def loadfile
        if File.exist?('docs/userinfo.yaml')
          @storage = YAML.load_file('docs/userinfo.yaml')
        else
          @storage = {}
        end
      end

      match /tw #(\d+)$/, method: :execute_id
      match /#(\d+)$/, method: :execute_id, prefix: /^@/

      def execute_id(m, id)
        return if check_ignore(m.user)
        tweet = @client.status(id)

        m.reply format_tweet(tweet)
      rescue ::Twitter::Error::NotFound => e
        m.reply "#{id} doesn't exist."
      rescue ::Twitter::Error => e
        m.reply "#{e.message.gsub(/user/i, id)}. (#{e.class})"
      end

      private

      def format_tweet(tweet)
        # Username (and retweeted username if applicable)
        head = []
        head << tweet.user.screen_name
        if tweet.retweet?
          head << (tweet.retweeted_status.user.nil? ? "(RT)" : ("(RT from %s)" % tweet.retweeted_status.user.screen_name))
        end

        # Tweet tweet
        body = expand_uris(CGI.unescapeHTML(!!tweet.retweet? ? tweet.retweeted_status.full_text : tweet.full_text).gsub("\n", " ").squeeze(" "), tweet.urls)

        # Metadata
        ttime = tweet.created_at
        tail = []
        tail << ttime.ago.to_words
        tail << "from #{tweet.place.full_name}" if !!tweet.place
        tail << "via #{tweet.source.gsub( %r{</?[^>]+?>}, "" )}"

        # URLs for tweet and replied to:
        urls = []
        urls << "https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id}"
        urls << "in reply to #{format_reply_url(tweet.in_reply_to_screen_name, tweet.in_reply_to_status_id)}" if tweet.reply?

        [Format(:bold, [*head, "»"] * " "), body, ["(", tail * " · ", ")"].join, urls * " "].join(" ")
      end

      def format_reply_url(username, id)
        "https://twitter.com/#{username}#{"/status/#{id}" if !!id}"
      end

      def expand_uris(t, uris)
        uris.each_with_object(t) {            |entity, tweet| tweet.gsub!(entity.url, entity.expanded_url)        }
      end

      def twitter_client
        ::Twitter::REST::Client.new do |c|
          c.consumer_key =        config[:access_keys][:consumer_key]
          c.consumer_secret =     config[:access_keys][:consumer_secret]
          c.access_token =        config[:access_keys][:access_token]
          c.access_token_secret = config[:access_keys][:access_token_secret]
        end
      end
    end
  end
end

## Written by Richard Banks for Eve-Bot "The Project for a Top-Tier IRC bot.
## E-mail: namaste@rawrnet.net
## Github: Namasteh
## Website: www.rawrnet.net
## IRC: irc.sinsira.net #Eve
## If you like this plugin please consider tipping me on gittip
