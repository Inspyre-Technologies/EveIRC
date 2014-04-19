require "json"
require "mechanize"
require_relative "config/check_master"
require_relative "config/check_ignore"

module Cinch
  module Plugins
    class UrlScraper
      include Cinch::Plugin
      include Cinch::Helpers

      listen_to :channel
      set :plugin_name, 'urlscraper'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
        If enabled, this plugin will return the title of the webpage that you or another user posts in the channel. For YouTube and IMDB there are special outputs for relevent information.
        Enable/Disable Usage:
        - !url [on/off]: This command will turn the URL Scraper on or off for the channel you use this command in. Only bot operators can use this command!
        USAGE
        
    def initialize(*args)
      super
        if File.exist?('docs/userinfo.yaml')
          @storage = YAML.load_file('docs/userinfo.yaml')
        else
          @storage = {}
        end
      end
      
      def listen(m)
        return if check_ignore(m.user)
        return if m.message.include? "nospoil"
        return unless config[:enabled_channels].include?(m.channel.name)
        # Create mechanize agent
        if @agent.nil?
          @agent = Mechanize.new
          @agent.user_agent_alias = "Linux Mozilla"
          @agent.max_history      = 0
        end

        URI.extract(m.message.gsub(/git@(gist.github.com):/,'git://\1/'), ["http", "https", "git"]).map do |link|
          link=~/^(.*?)[:;,\)]?$/
          $1
        end.each do |link|
          # Fetch data
          begin
            if git = link =~ /^git:\/\/(gist.github.com\/.*)\.git$/
              link = "https://#{$1}"
            end
            uri  = URI.parse(link)
            page = @agent.get(link)
          rescue Mechanize::ResponseCodeError
            if "www.youtube.com" == uri.host
              m.reply "Thank you, GEMA!"
            else
              m.reply "Y U POST BROKEN LINKS?", true
            end

            next
          end

          # Replace strange characters
          title = page.title.gsub(/[\x00-\x1f]*/, "").gsub(/[ ]{2,}/, " ").strip rescue nil

          # Check host
          case uri.host
            when "www.imdb.com"
              # Get user rating
              rating = page.search("//strong/span[@itemprop='ratingValue']").text

              # Get votes
              votes = page.search("//a/span[@itemprop='ratingCount']").text

              m.reply "#{m.user.nick}'s IMDB Title: %s (Rating: %s/10 from %s users)" % [
                title, rating, votes
              ]
              
            when "www.youtube.com"
              # Reload with nofeather
              page = @agent.get(link + "&nofeather=True")

              # Get page hits
              hits = page.search("//span[@class='watch-view-count ']")
              hits = hits.text.gsub(/[.,]/, ",")

              # Get likes
              likes = page.search("//span[@class='likes-count']")
              likes = likes.text.gsub(/[.,]/, ",")
              
              # Get dislikes
              dislikes = page.search("//span[@class='dislikes-count']")
              dislikes = dislikes.text.gsub(/[.,]/, ",")

              m.reply "#{m.user.nick}'s YT Title: %s (Views: %s, Likes: %s || Dislikes: %s)" % [
                title, hits.strip, likes.strip, dislikes.strip
              ]
              

            when "gist.github.com"
              # Get owner
              owner = page.search("//div[@class='name']/a").inner_html

              # Get time
              age = page.search("//span[@class='date']/time")
              age = age.first[:datetime] rescue age.text if age
              age = Time.parse(age) rescue nil
              age = age.strftime("%Y-%m-%d %H:%M") if age

              if git
                m.reply "Title: %s (at %s, %s on %s), Url: %s" % [
                  title, uri.host, owner, age, link
                ]
              else
                m.reply "Title: %s (at %s, %s on %s)" % [
                  title, uri.host, owner, age
                ]
              end
            when "pastie.org"
              # Get time
              age = Time.parse(page.search("//span[@class='typo_date']").text)
              age = age.strftime("%Y-%m-%d %H:%M")

              m.reply "Title: %s (at %s, on %s)" % [
                title, uri.host, age
              ]
            when "subforge.org", "subtle.de"
              m.reply "Title: %s (at %s)" % [ title, uri.host ]
              
            when "twitter.com"
              if link =~ /\/status\/(\d+)$/
                json      = @agent.get("https://api.twitter.com/1/statuses/show/#{$1}.json?trim_user=1").body
                tweet     = JSON.parse(json)
                unescaped = CGI.unescapeHTML(tweet["text"])

                m.reply "@%s: %s" % [ tweet["user"]["screen_name"], unescaped ]
              else
                m.reply "Broken twitter link: %s (at %s)" % [ title, uri.host ] if title
              end
            else
              m.reply "Title: %s (at %s)" % [ title, uri.host ] if title
            end
        end
      end

  set :prefix, /^~/
  match /url (on|off)$/
  
  def execute(m, option)
    return if check_ignore(m.user)
    reload
    begin
      return unless check_master(m.user)
      
      @url = option == "on"
      
      case option
        when "on"
          config[:enabled_channels] << m.channel.name
        else
          config[:enabled_channels].delete(m.channel.name)
        end
        
        m.reply Format(:green, "URL Scraping for #{m.channel} is now #{@url ? 'enabled' : 'disabled'}!")
        
        @bot.debug("#{self.class.name} → #{config[:enabled_channels].inspect}");
        
      rescue 
        m.reply Format(:red, "Error: #{$!}")
      end
    end
      
    def reload
      if File.exist?('docs/userinfo.yaml')
        @storage = YAML.load_file('docs/userinfo.yaml')
      else
        @storage = {}
      end
    end
  end
end
end
