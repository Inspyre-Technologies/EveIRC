require 'highline/import'
require_relative '../helpers/logger'

module Cinch
  module Plugins
    class FirstRun
      include Cinch::Helpers
      include Cinch::Plugin

      def initialize(*args)
        super
        @settings = {} unless @settings
        # First explain what Eve-Bot is and why we are using this wizard
        say("Hello, and welcome to Eve-Bot by <%= color('Rawr', BOLD, RED) %><%= color('Net', BOLD, MAGENTA) %>!")
        say("Before you can get your bot on IRC we need to go through the configuration wizard. Grab some coffee (or preferred beverage), and let's go!")

        # Find out what nick the user wants the bot to have
        say("Just in case you don't get another chance, we should start by setting your bot's nick.")
        botnick = ask("What would you like to name your bot? ") { |nick|
                                                                  nick.validate = /\A\w+\Z/
                                                                nick.default = "Eve"
                                                                nick.responses[:ask_on_error] = "Please specify a nickname for your bot: "
                                                                nick.confirm = "Are you sure that you wish to set the bot's nickname to <%= @answer %>? [yes/no]: "
                                                                }

        @settings['nick'] = "#{botnick}"

        # Determine a global prefix for the bot
        say("#{botnick} will respond to prefix characters before commands. For example; !command where '!' is the prefix and 'command' is the command")
        choose do |prefix|
          prefix.prompt = "Please select the prefix you would like to the bot to listen to: "
          prefix.choice("!") { @settings['prefix'] = "default" }
          prefix.choice(".") { @settings['prefix'] = '/^./' }
          prefix.choice("~") { @settings['prefix'] = '/^~/' }
          prefix.confirm = "\nAre you sure? [yes/no]: "
          prefix.responses[:ask_on_error] = prefix
        end

        pfix = @settings['prefix']

        pf = "!"
        if pfix.include?(".")
          pf = "."
        end
        if pfix.include?("~")
          pf = "~"
        end

        irc_server = ask("Please enter the server address you would like the bot to connect to: ") {|server|
          server.responses[:ask_on_error] = "Please specify the IRC server address you'd like the bot to connect to: "
          server.confirm = "Are you sure that you'd like to set <%= @answer %> as the IRC server the bot will connect to? [yes/no]: "
          }
        @settings['irc_server'] = irc_server.to_s

        server_port = ask("What port would you like the bot to connect through? [6667]") {|port|
          port.default = "6667"
          port.responses[:ask_on_error] = "Please specify a port that you'd like the bot to connect through: "
          port.confirm = "Are you sure you want to set connect to #{irc_server} through port <%= @answer %>?"
          }
        @settings['server_port'] = server_port.to_s

        if agree("Does #{irc_server}'s port #{server_port} use SSL? [yes/no]: ")
          @settings['server_ssl'] = true
          if agree("Does #{irc_server} use a self-signed SSL certificate? [yes/no]: ")
            @settings['ssl_verify'] = false
          else
            @settings['ssl_verify'] = true
          end
        else
          @settings['server_ssl'] = false
        end

        # Attempt to get e-mail from user for NickServ registration
        say("#{botnick} will need an e-mail for certain things, like registering for NickServ. Please take note that the e-mail won't necessarily be publicly available, but that option is available for support!")
        if agree("Would you like to provide an e-mail for #{botnick} to use for things like registering to NickServ? [yes/no]: ")
          master_email = ask("Please enter an e-mail address for #{botnick} to use: ") {|email|
                                                                                        email.validate = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
                                                                                       email.responses[:ask_on_error] = "Please specify an e-mail address for #{botnick}: "
                                                                                       email.confirm = "Are you sure that you wish to set #{botnick}'s e-mail to <%= @answer %>? [yes/no]: "
                                                                                       }
          @settings['email'] = master_email.to_s
        else
          say("Very well, no e-mail is being set.")
          @settings['email'] = false
        end

        if @settings['email'] == false
          say("Since you didn't set an e-mail for #{botnick} to use, #{botnick} will not be able to register for NickServ.")
          say("If you so wish; at a later time you can set up #{botnick} using the following command in IRC: #{pf}bot-email <e-mail>")
          log_message("message", "Skipping NickServ set-up...")
        else
          if agree("Would you like to prepare the bot for registering and identifying with NickServ? [yes/no] ")
            bot_pass = ask("Please enter a password for #{botnick} to register/indentify to NickServ with: ") do |p|
            end
            @settings['password'] = bot_pass.to_s
          else
            say("Very well, not configuring NickServ authentication.")
            say("Please keep in mind that you can add a NickServ password to #{botnick} by using the following command in IRC: #{pf}bot-password <password>")
            @settings['password'] = false
          end
        end
        update_settings
      end

      def update_settings
        log_message("message", "Writing settings file...")
          begin
          synchronize(:update) do
            File.open('config/settings/settings.yaml', 'w') do |fh|
              YAML.dump(@settings, fh)
            end
          end
        rescue
          log_message("error", "Error creating file settings.yaml: #{$!}")
          abort("Exiting due to above error!")
        end
        log_message("message", "Successfully wrote settings file!")
      end
    end
  end
end
