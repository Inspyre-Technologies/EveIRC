module Cinch
  module Plugins
    
    ## lib/yourls.rb
    # @author Taylor-Jayde J. Blackstone <t.blackstone@inspyre.tech>
    # The Yourls plugin will allow users on IRC to have the bot send
    # shortened urls to the channel
    class Yourls
      require 'yourls'
      
      ## required_options:
      # If you enabled this plugin, but did not add the plugins
      # options in Eve.rb then you will most likely get an exception
      # complaining that this plugin cannot find these options. In the
      # bot's configuration block add this:
      #
      # c.plugins.options[Cinch::Plugins::Yourls] = { yourls_server: 'foo.com/yourls',
      #                                                   secret_id: 'bar',
      #                                                   enabled_channels: 'docs/yourls.conf',
      #                                                   scrape_title: 'never',
      #                                                   collection_channel: '#services'}
      # For more information see the wiki:

      set :required_options, %i[secret_id yourls_server enabled_channels scrape_title collection_channel]
      set :plugin_name, 'yourls'
      set :help, <<-USAGE.gsub(/^ {6}/, '')
      Send the bot a link and it will shorten the URL and send it to the channel:
        * !yourls #lobby <long url>: If sent in a private message this will send your link to the channel

      
      USAGE
      
      
      match /short (.+)/i, method: :yourls
      
      def initialize
      
      end
      
      def yourls(m)
        client = Yourls.new(your_hosted_yourls_address, your_hosted_yourls_api_key)


      end
      
      
    end
  end
end
