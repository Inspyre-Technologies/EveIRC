# coding: utf-8

require "oj"
require "twitter"
require "cgi"

module Cinch
  module Plugins
    class Twitter
      include Cinch::Plugin
      
      TWITTER_URL_BASE = 'https://twitter.com/'
      ERROR_TPL = Cinch::Formatting.format(:bold, 'Uhoh! »') + ' %s'
      
      set(
        plugin_name: "twitter",
        help: "Access Twitter from the comfort of your IRC client! Usage:\n* `@<username><-D>` - Gets the latest tweet of the specified user, or the tweet 'D' tweets back, between 1 and 20.\n",
        required_options: [:access_keys])
      
      def initialize *args
        super
        ::Twitter.configure do |c|
          c.consumer_key = config[:access_keys][:consumer_key]
          c.consumer_secret = config[:access_keys][:consumer_secret]
          c.oauth_token = config[:access_keys][:oauth_token]
          c.oauth_token_secret = config[:access_keys][:oauth_token_secret]
        end
      end
      
      match /tw (\w+)(?:-(\d+))?$/, method: :execute_tweet
      match /(\w+)(?:-(\d+))?$/, method: :execute_tweet, prefix: /^@/
      def execute_tweet m, username, offset
        offset ||= 0
        
        user = ::Twitter.user(username)
        
        return m.reply ERROR_TPL % "#{user.screen_name}'s tweets are protected." if user.protected?
        return m.reply "#{user.screen_name} is lame because they haven't tweeted yet!" if user.status.nil?
        
        # Getting the user's 20 latest tweets if our offset is greater than 0:
        if offset.to_i > 0
          tweets = ::Twitter.user_timeline(user)
          return m.reply ERROR_TPL % "You cannot backtrack more than #{tweets.count.pred} tweets before the current tweet." if offset.to_i > tweets.count.pred
          tweet = tweets[offset.to_i]
        # Otherwise, just get the latest tweet from the user object.
        else
          tweet = user.status
        end
        m.reply format_tweet(tweet)
      rescue ::Twitter::Error::NotFound => e
        m.reply ERROR_TPL % "#{username} doesn't exist."
      rescue ::Twitter::Error => e
        m.reply ERROR_TPL % "#{e.message.gsub(/user/i, username)}. (#{e.class})"
      end
      
      
      match /tw #(\d+)$/, method: :execute_id
      match /#(\d+)$/, method: :execute_id, prefix: /^@/
      def execute_id m, id
        tweet = ::Twitter.status(id)
        
        #return m.reply ERROR_TPL % "#{user.screen_name}'s tweets are protected." if user.protected?
        
        m.reply format_tweet(tweet)
      rescue ::Twitter::Error::NotFound => e
        m.reply ERROR_TPL % "#{id} doesn't exist."
      rescue ::Twitter::Error => e
        m.reply ERROR_TPL % "#{e.message.gsub(/user/i, id)}. (#{e.class})" 
      end
      
      private
      
      def format_tweet tweet
        # Username (and retweeted username if applicable)
        head = []
        head << tweet.user.screen_name
        if tweet.retweet?
          head << (tweet.retweeted_status.user.nil? ? "(RT)" : ("(RT from %s)" % tweet.retweeted_status.user.screen_name))
        end
        
        # Tweet tweet
        body = expand_uris(CGI.unescapeHTML(!!tweet.retweet? ? tweet.retweeted_status.full_text : tweet.full_text).gsub("\n", " ").squeeze(" "), tweet.urls)
        
        # Metadata
        tail = []
        tail << tweet.created_at.strftime("at %b %-d %Y, %-l:%M %p %Z")
        tail << "from #{tweet.place.full_name}" if !!tweet.place
        tail << "via #{tweet.source.gsub( %r{</?[^>]+?>}, '' )}"
        
        # URLs for tweet and replied to:
        urls = []
        urls << "#{TWITTER_URL_BASE}#{tweet.user.screen_name}/status/#{tweet.id}"
        urls << "in reply to #{format_reply_url(tweet.in_reply_to_screen_name, tweet.in_reply_to_status_id)}" if tweet.reply?
        
        [Format(:bold, [*head, '»'] * ' '), body, ['(', tail * ' · ', ')'].join, urls * ' '].join(' ')
      end
      
      def format_reply_url(username, id)
        "#{TWITTER_URL_BASE}#{username}#{"/status/#{id}" if !!id}"
      end
      
      def expand_uris(t, uris)
        uris.each_with_object(t) {|entity,tweet| tweet.gsub!(entity.url, entity.expanded_url) }
      end
      
    end
  end
end
