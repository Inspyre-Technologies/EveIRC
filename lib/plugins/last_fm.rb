require 'cinch'
require 'json'

module Cinch
  module Plugins
    class LastFm
      include Cinch::Plugin

      BaseURL = "http://ws.audioscrobbler.com/2.0/"

      def initialize(*args)
        super
        if File.exist?('docs/userinfo.yaml')
          @storage = YAML.load_file('docs/userinfo.yaml')
        else
          @storage = {}
        end
      end

      match /np/, method: :nowPlaying

      def nowPlaying(m)
        reload
        return m.reply "You have no information saved in my database. To save your lastfm username type !set-lastfm <username>" if !@storage.key?(m.user.nick)
        return m.reply "Your database table has no LastFM username saved. To save a LastFM username type !set-lastfm <username>" if !@storage[m.user.nick].key? 'lastfm'

        userName = @storage[m.user.nick]['lastfm']

        key = config[:key]

        rTracks   = JSON.parse(open("#{BaseURL}?method=user.getrecenttracks&user=#{userName}&api_key=#{key}&format=json").read)['recenttracks']['track']

        return m.reply "You don't seem to be playing anything right now. Check back again later!" if rTracks[0]['@attr'].nil?

        artist   = rTracks[0]['artist']['#text']
        track    = rTracks[0]['name']
        album    = rTracks[0]['album']['#text']
        trackURL = rTracks[0]['url']

        trackURL = trackURL.gsub('\\', '')
        
        # If we send the username with the track.getInfo request we get additional info such as userLoved
        # we have to URI.encode because of tracks with special characters and spaces
        trackInfo = JSON.parse(open(URI.encode("#{BaseURL}?method=track.getInfo&username=#{userName}&artist=#{artist}&track=#{track}&api_key=#{key}&format=json")).read)
        
        loved = ":("
        if (trackInfo['track']['userloved'] == "1")
          loved = "4<3"
        end

        m.reply "#{m.user.nick} - Track: \"4#{track}\" | Artist: 7#{artist} | Album: \"10#{album}\" | Loved #{loved} | Listen to this now: #{trackURL}"
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
