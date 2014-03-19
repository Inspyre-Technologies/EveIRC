# -*- coding: utf-8 -*-
require 'cinch'
require 'twitter'

module Cinch::Plugins
  class TwitterStatus
    include Cinch::Plugin
    
      TWITTER_URL_BASE = 'https://twitter.com/'
      ERROR_TPL = Cinch::Formatting.format(:bold, 'Uhoh! »') + ' %s'

    self.help = 'Just link to a specific twitter status and I will post the content of that tweet.'

    listen_to :channel
    timer 15, method: :check_watched

    def initialize(*args)
      super
      if config
        @client = ::Twitter::REST::Client.new do |c|
          c.consumer_key =        config[:consumer_key]
          c.consumer_secret =     config[:consumer_secret]
          c.oauth_token =         config[:access_token]
          c.oauth_token_secret =  config[:access_token_secret]
        end

        if config[:watchers]
          @watched = Hash.new
          config[:watchers].each_pair do |chan, users|
            @watched[chan] = Hash.new
            users.each { |user| refresh_cache(chan, user) }
          end
        end
      end
    end

    def check_watched
      return unless @watched

      @watched.keys.each do |chan|
        @watched[chan].keys.each do |user|
          begin 
            # Just check the last tweet, if they are posting more than once
            # every timer tick I don't want to spam the channel. 
            tweet = @client.user_timeline(user).first
            unless @watched[chan][user].include?(tweet.id)
              @watched[chan][user] << tweet.id
              
              msg = "New tweet from #{format_tweet(tweet)} "
              Channel(chan).send msg unless msg.nil?
            end
            refresh_cache(chan, user)
          rescue ::Twitter::Error::NotFound
            debug "You have set an invalid or protected user (#{user}) to watch, please correct this error"
          end
        end
      end
    end

    def listen(m)
      urls = URI.extract(m.message, ["http", "https"])
      urls.each do |url|
        if url.match(/^https?:\/\/mobile|w{3}?\.?twitter\.com/)
          if tweet = url.match(/https?:\/\/mobile|w{3}?\.?twitter\.com\/?#?!?\/([^\/]+)\/statuse?s?\/(\d+)\/?/)
            msg = format_tweet(tweet)
            m.reply msg unless msg.nil?
          end
        end
      end
    rescue ::Twitter::Error::NotFound
      debug "User posted an invalid twitter status"
    rescue ::Twitter::Error::Forbidden
      debug "User attempted to post a Protected Tweet or you have not set valid Twitter credentials."
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

    def refresh_cache(chan, user)
      @watched[chan][user] = []
      @client.user_timeline(user).each do |tweet|
        @watched[chan][user] << tweet.id
      end
    rescue ::Twitter::Error::NotFound
      debug "You have set an invalid or protected user (#{user}) to watch, please correct this error"
    end
  end
end