require 'json'
require 'open-uri'
require 'cgi'
require 'uri'
require 'action_view'
require 'date'
require_relative "config/check_ignore"

module Cinch
  module Plugins
    class Reddit
      include Cinch::Plugin
      include ActionView::Helpers::DateHelper

      set :plugin_name, 'reddit'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
      You can use the bot to get certain information from Reddit!
      Usage:
      * !reddit karma <reddit user>: Check the karma data of <reddit user> and have it displayed in the channel.
      * !reddit (mods|moderators) <subreddit>: This command queries Reddit and returns the moderators of <subreddit>.
      * !reddit (subs|subscribers) <subreddit>: This command queries Reddit and returns with the number of subscribers of <subreddit>.
      * !reddit lookup: This command will look up a thread that matches your terms. (This is a beta command).
      * !reddit link <link>: When invoked this command will return with the thread data of <link>.
      USAGE


      RedditURL = "http://www.reddit.com"

      def client(target)
	open(target, "User-Agent" => "eve-bot").read
      end

      def pluralJoin(array)
        return array[0] unless array.length > 1
        array[0..-2].join(", ") + ", and " + array[-1]
      end

      match /reddit karma (.+)/, method: :karma

      def karma(m, user)
	return if check_ignore(m.user)

	url = "%s/user/%s/about.json" % [RedditURL, user]
	data = JSON.parse(client url)["data"] rescue nil

	if data
	  link_karma = data["link_karma"]
	  link_karma = link_karma.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse

	  comment_karma = data["comment_karma"]
	  comment_karma = comment_karma.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse

	  name = data["name"]

	  m.reply "%s has %s link karma, and %s comment karma" % ["3#{name}", "#{link_karma}", "#{comment_karma}"]
	else
	  m.reply "I'm sorry, I can't find #{user} on Reddit!"
	end
      end

      match /reddit moderators (.+)/, method: :moderators
      match /reddit mods (.+)/, method: :moderators

      def moderators(m, subreddit)
	return if check_ignore(m.user)

	url = "%s/r/%s/about/moderators.json" % [RedditURL, subreddit]
	data = JSON.parse(client url)["data"]["children"] rescue nil

	if data
	  mods = []
	  data.each { |mod| mods << mod["name"] }

	  numMods = data.count

	  m.reply "/r/%s has %s moderator(s): %s" % ["#{subreddit}", "#{numMods}", pluralJoin(mods)]
	else
	  m.reply "I'm sorry, I can't find #{subreddit} on Reddit!"
	end
      end

      match /reddit subscribers (\w+)/, method: :subscribers
      match /reddit subs (\w+)/, method: :subscribers

      def subscribers(m, subreddit)
	return if check_ignore(m.user)

	url = "%s/r/%s/about.json" % [RedditURL, subreddit]
	data = JSON.parse(client url)["data"]["subscribers"] rescue nil

	subscribers = data.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse

	if data
	  m.reply "/r/%s has %s subscribers!" % ["#{subreddit}", "#{subscribers}"]
	else
	  m.reply "I'm sorry, I can't find #{subreddit} on Reddit!"
	end
      end

      match /reddit lookup (\S+)/, method: :lookup

      def lookup(m, query)
	return if check_ignore(m.user)

        url = "%s/api/info.json?url=%s" % [RedditURL, query]
        data = JSON.parse(client url)["data"]["children"][0]["data"] rescue nil

	score = data['score']
	score = score.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse

	ups = data['ups']
	ups = ups.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse

	downs = data['downs']
	downs = downs.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse

        if data
          m.reply("%s - \"%.100s\" %s(%s|%s) by %s, %s ago, to /r/%s" % [
	                                                                 "http://redd.it/#{data['id']}",
	                                                                 Format(:bold, data['title']),
	                                                                 Format(:grey, score),
	                                                                 Format(:orange, "+" + ups),
	                                                                 Format(:blue, "-" + downs),
	                                                                 data['author'],
	                                                                 time_ago_in_words(DateTime.strptime(data['created'].to_s,'%s')),
	                                                                 data['subreddit']
	                                                                ])
	else
          m.reply("I couldn't find that for some reason. It might be my fault, or it might be reddit's")
        end
      end

      match /reddit link (\S+)/, method: :linkLookup
      def linkLookup(m, query)
	return if check_ignore(m.user)

        return nil unless URI.parse(query).host.end_with?('reddit.com')

        thing_id = URI.parse(query).path.split('/')[4]
        url = "%s/api/info.json?id=t3_%s" % [RedditURL, thing_id]
        data = JSON.parse(client url)["data"]["children"][0]["data"] rescue nil

	score = data['score']
	score = score.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse

	ups = data['ups']
	ups = ups.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse

	downs = data['downs']
	downs = downs.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse

	if data
          m.reply("|\"%.100s\"| %s(%s|%s) by %s, %s ago, to /r/%s | %s |" % [
	                                                                 Format(:bold, data['title']),
	                                                                 Format(:orange, score),
	                                                                 Format(:green, "+" + ups),
	                                                                 Format(:red, "-" + downs),
	                                                                 data['author'],
	                                                                 time_ago_in_words(DateTime.strptime(data['created'].to_s,'%s')),
	                                                                 data['subreddit'],
	                                                                 "http://redd.it/#{data['id']}"
	                                                                ])
	else
          m.reply("I couldn't find that for some reason. It might be my fault, or it might be reddit's")
        end
      end

    end
  end
end
