require 'cinch'
require 'json'

module Cinch
  module Plugins

    ## lib/yourls.rb
    # @author Taylor-Jayde J. Blackstone <t.blackstone@inspyre.tech>
    # The Yourls plugin will allow users on IRC to have the bot send
    # shortened urls to the channel
    class Yourls
      include Cinch::Plugin
  
      ## required_options:
      # If you enabled this plugin, but did not add the plugins
      # options in Eve.rb then you will most likely get an exception
      # complaining that this plugin cannot find these options. In the
      # bot's configuration block add this:
      #
      # c.plugins.options[Cinch::Plugins::Yourls] = { yourls_server: 'foo.com/yourls',
      #                                                   secret_id: 'bar',
      #                                                   disabled_channels: ['#foo', '#bar'],
      #                                                   scrape_title: 'never',
      #                                                   collection_channel: '#services'}
      # For more information see the wiki:
  
      set :required_options, %i[secret_id yourls_server disabled_channels scrape_title collection_channel]
      set :plugin_name, 'yourls'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
      Send the bot a link and it will shorten the URL and send it to the channel:
        * !short <#channel> <long url>: If sent in a private message this will send your link to the channel


      USAGE
  
  
      match /short (#.+?) (.+)/i
  
      def execute(m, channel, url)
    
        token          = config[:secret_id]
        disabled_chans = config[:disabled_channels]
    
        server = config[:yourls_server]
    
        if m.user.channels.include? channel
          if disabled_chans.include? channel
            m.reply m.user.nick + ', that is a channel I\'m not permitted to send shortened URLS to'
          else
            data   = JSON.parse(open("#{server}#{token}&action=shorturl&url=#{url}&format=json").read)
            status = data['status']
            if status == 'success'
              short_url = data['shorturl']
              m.reply 'Your shortened url is: ' + short_url
              message = m.user.nick + ' sent a URL: ' + short_url
              Channel(channel).send(message)
              collector_message = m.user.nick + ' sent a URL to ' + channel + ': ' + short_url
              unless channel == config[:collection_channel]
                Channel(config[:collection_channel]).send(collector_message)
              end
            end
          end
        else
          # Let the user know if they're not in the channel, and
          # don't send a message if they're not.
          m.reply m.user.nick + ', you are not in ' + channel
        end
      end
    end
  end
end
