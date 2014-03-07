require 'cinch'
require_relative "config/check_master"

module Cinch::Plugins
  class Help
    include Cinch::Plugin
    include Cinch::Helpers
    
    set :prefix, /^~/
    match "help"
    
    def initialize(*args)
      super
        if File.exist?('userinfo.yaml')
          @storage = YAML.load_file('userinfo.yaml')
        else
          @storage = {}
        end
      end
  
  def execute(m)
      unless check_master(m.user)
        m.user.send Format(:green, "Hello, #{m.user.nick}")
        m.user.send Format(:green, "You can get further information on a plugin by typing ~help <plugin name> IN A PM. Don't do it in a channel!!")
        m.user.send Format(:orange, "memo, seen, urban, eightball, decider, factcore, weather, twitter, valentineboxx, wikipedia, google, youtube, 4chan, math, isitup, bitcoin, userinfo")
      return;
    end
        m.user.send Format(:green, "Hello, #{m.user.nick}")
        m.user.send Format(:green, "You can get further information on a plugin by typing ~help <plugin name> IN A PM. Don't do it in a channel!!")
        m.user.send Format(:orange, "memo, seen, urban, eightball, decider, factcore, weather, twitter, valentineboxx, wikipedia, google, youtube, 4chan, math, isitup, bitcoin, userinfo")
        m.user.send Format(:red, "The following plugins are only available to operators of the bot! USE WITH CAUTION!! USE OF EVERY ONE OF THESE PLUGINS IS REPORTED!!!")
        m.user.send Format(:red, "channelcp, controlpanel, privatecp, privchancp, urlscraper, pluginmanagement")
      end
    end
  end