require 'cinch'
require 'json'
require 'addressable/uri'

module Cinch
  module Plugins
    class LastFm
      include Cinch::Plugin

      set :required_options, [:key]
      set :plugin_name, 'lastfm'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
      The LastFM plugin queries Last.FM when you trigger it.
      Usage:
      * !np: This will return what you're currently listening to via Last.FM
      USAGE

      BASEURL = "http://ws.audioscrobbler.com/2.0/"

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
        key = config[:key]
        reload
        return m.reply "You have no information saved in my database. To save your lastfm username type !set-lastfm <username>" if !@storage.key?(m.user.nick)
        return m.reply "Your database table has no LastFM username saved. To save a LastFM username type !set-lastfm <username>" if !@storage[m.user.nick].key? 'lastfm'

        userName = @storage[m.user.nick]['lastfm']

        key = config[:key]

        track = nil

        rTracks   = JSON.parse(open("#{BASEURL}?method=user.getrecenttracks&user=#{userName}&api_key=#{key}&format=json").read)['recenttracks']['track']

        if rTracks.length > 0
          track = rTracks[0]
        else
          return m.reply "User has empty library"
        end

        # Set aside a couple of human-readable versions of the artist and track names

        artist = track['artist']['#text']
        track_title = track['name']

        # Encode artist and track names for proper searching on LastFM
        
        artist_encoded = Addressable::URI.encode_component(artist)
        if artist_encoded.include?('&')
          artist_encoded.gsub!('&', '%26')
        end
        track_title_encoded = Addressable::URI.encode_component(track_title)
        if track_title_encoded.include?('&')
          track_title_encoded.gsub!('&', '%26')
        end

        # As of this time I don't see a need to encode the artist

        album = "N/A"
        if !track['album'].nil?
          album = track['album']['#text']
        end

        # Now we search LastFM for more information on the song.
        
        lastfm_url = "#{BASEURL}?method=track.getInfo&username=#{userName}&artist=#{artist_encoded}&track=#{track_title_encoded}&api_key=#{key}&format=json"
        if lastfm_url.include?('%2625')
          lastfm_url.gsub!('%26')
        end
        trackInfo = JSON.parse(open(lastfm_url).read)

        loved = ":("
        if (trackInfo['track']['userloved'] == "1")
          loved = "4<3"
        end

        uPlays = trackInfo['track']['userplaycount']

        if uPlays.nil?
          uPlays = "1"
        else
          uPlays = uPlays.to_i + 1
        end

        topTags = trackInfo['track']['toptags']
        tags = []
        if !topTags.is_a?(String)# when there are no tags on a track it returns a string (no keys)
          for i in topTags['tag']
            tags << i['name']
          end
          # sometimes tracks have no tags so lets fetch the artist's tags
        else
          artistInfo = JSON.parse(open(URI.encode("#{BASEURL}?method=artist.getInfo&artist=#{artist_encoded}&api_key=#{key}&format=json")).read)
          topTags = artistInfo['artist']['tags']
          for i in topTags['tag']
            tags << i['name']
          end
        end

        if track["@attr"].nil?
          ts_track = track['date']['uts'].to_i
          ts_now = Time.now.to_i
          diff = ts_now - ts_track
          if diff > 240 # last 4 minutes
            return m.reply "You haven't scrobbled anything in a while!"
          else
            return m.reply "(0,5Last.FM)#{m.user.nick} - Track: \"4#{track_title}\" | Artist: 7#{artist} | Album: \"10#{album}\" | Loved #{loved} | Plays: #{uPlays} | #{tags.join(", ")}"
          end
        end

        m.reply "(0,5Last.FM)#{m.user.nick} - Track: \"4#{track_title}\" | Artist: 7#{artist} | Album: \"10#{album}\" | Loved #{loved} | Plays: #{uPlays} | #{tags.join(", ")}"
      rescue; m.reply("Something went wrong, try again with a different song!")
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
