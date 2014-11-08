require 'cinch'
require 'json'

module Cinch
  module Plugins
    class LastFm
      include Cinch::Plugin

      set :required_options, [:key]
      set :plugin_name, 'lastfm'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
      The LastFM plugin queries Last.FM when you trigger it. Using the Last.FM API the user can get "now playing" information and use the "TasteOMeter" to compare their tastes with other IRC users or usernames on Last.FM.
      Usage:
      * !np: This will return what you're currently listening to via Last.FM
      * !compare <nick|username>: Using an IRC nick of someone who has their information stored in my databases or just a Last.FM username you can compare your tastes!
      USAGE

      baseURL = "http://ws.audioscrobbler.com/2.0/"

      CmpBars = ["[4====            ]",
                  "[4====7====        ]",
                  "[4====7====8====    ]",
                  "[4====7====8====9====]",
                  "[                ]"]

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

        rTracks   = JSON.parse(open("#{baseURL}?method=user.getrecenttracks&user=#{userName}&api_key=#{key}&format=json").read)['recenttracks']['track']

        if rTracks.length > 0
          track = rTracks[0]
          ts_track = track['date']['uts'].to_i
          ts_now = Time.now.to_i
          diff = ts_now - ts_track
          if diff > 240 # last 4 minutes
            return m.reply "You haven't scrobbled anything in a while!"
          end
        end

        artist   = track['artist']['#text']
        track    = track['name']
        album    = "N/A"
        if !track['album'].nil?
          album = track['album']['#text']
        end

        # If we send the username with the track.getInfo request we get additional info such as userLoved
        # we have to URI.encode because of tracks with special characters and spaces
        trackInfo = JSON.parse(open(URI.encode("#{baseURL}?method=track.getInfo&username=#{userName}&artist=#{artist}&track=#{track}&api_key=#{key}&format=json")).read)

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
          artistInfo = JSON.parse(open(URI.encode("#{baseURL}?method=artist.getInfo&artist=#{artist}&api_key=#{key}&format=json")).read)
          topTags = artistInfo['artist']['tags']
          for i in topTags['tag']
            tags << i['name']
          end
        end

        m.reply "(0,5Last.FM)#{m.user.nick} - Track: \"4#{track}\" | Artist: 7#{artist} | Album: \"10#{album}\" | Loved #{loved} | Plays: #{uPlays} | #{tags.join(", ")}"
      end

      match /compare (.+)/, method: :compare

      def compare(m, user)
        key = config[:key]
        reload

        return m.reply "You have no information saved in my database. To save your lastfm username type !set-lastfm <username>" if !@storage.key?(m.user.nick)
        return m.reply "Your database table has no LastFM username saved. To save a LastFM username type !set-lastfm <username>" if !@storage[m.user.nick].key? 'lastfm'

        user1 = @storage[m.user.nick]['lastfm']

        if !@storage.key?(user)
          m.reply "#{user} has no information in my database. Trying LastFM username..."

          user2 = user
        else
          if !@storage[user].key? 'lastfm'
            m.reply "#{user} has no LastFM username set in my database. Trying LastFM username..."

            user2 = user
          else
            user2 = @storage[user]['lastfm']
          end
        end

        compareInfo = JSON.parse(open(URI.encode("#{baseURL}?method=tasteometer.compare&type1=user&type2=user&value1=#{user1}&value2=#{user2}&api_key=#{key}&format=json")).read)

        return m.reply "Invalid username #{user2}." if compareInfo['error']

        index = (compareInfo['comparison']['result']['score'].to_f * 100).to_i

        bar = CmpBars[4]
        if index >= 1
          bar = CmpBars[(index / 25.01).to_i]
        end

        artists = []

        raw_artists = compareInfo['comparison']['result']['artists']

        if !raw_artists.key? '@attr'
          artists = ["N/A"]
        else
          for i in raw_artists['artist']
            artists << i['name']
          end
        end

        m.reply "(0,5Last.FM) Comparison: #{m.user.nick} #{bar} #{user} | Similarity #{index}% | Common artists: #{artists.join(", ")}"
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
