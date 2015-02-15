require_relative '../helpers/logger'

module Cinch
  module Plugins
    class AiConfig
      include Cinch::Plugin
      
      def initialize(*args)
        super
        @aiConf = {} unless @aiConf
        puts "\e[H\e[2J"
        say("Welcome to <%= color('eveMotion', BOLD, YELLOW) %>!")
        say("<%= color('eveMotion', BOLD, YELLOW) %> attempts to mimic/produce fuzzy logic for your IRC bot")
        say("Now we need to go through and set the basic settings for your bot!")
        choose do |gender|
          gender.prompt = "First, what will be the bot's gender?: "
          gender.default = "Female"
          gender.choice("Male") do @aiConf['gender'] = "male" end
          gender.choice("Female") do @aiConf['gender'] = "female" end
          gender.confirm = "\nAre you sure? [yes/no]: "
          gender.responses[:ask_on_error] = gender
        end
        default_nick = "Adam" if @aiConf['gender'] == "male"
        default_nick = "Eve" if @aiConf['gender'] == "female"
        botnick = ask("What will be the name of your bot?: ") { |n|
                                                                n.validate = /\A\w+\Z/
                                                              n.default = "#{default_nick}"
                                                              n.responses[:ask_on_error] = "What will be the name of your bot?: "
                                                              n.confirm = "\nAre you sure you wish to set the bot's nickname to <%= @answer %>? [yes/no]: "
                                                              }
        @aiConf['nick'] = botnick.to_s
        choose do |sexuality|
          sexuality.prompt = "What will be #{botnick}'s sexuality?: "
          sexuality.default = "Bisexual"
          sexuality.choice("Heterosexual") do @aiConf['sexuality'] = "heterosexual" end
          sexuality.choice("Homosexual") do @aiConf['sexuality'] = "homosexual" end
          sexuality.choice("Bisexual") do @aiConf['sexuality'] = "bisexual" end
          sexuality.choice("Asexual") do @aiConf['sexuality'] = "asexual" end
          sexuality.confirm = "\nAre you sure? [yes/no]: "
          sexuality.responses[:ask_on_error] = sexuality
        end
        choose do |disposition|
          disposition.prompt = "What will be #{botnick}'s general disposition? "
          disposition.choice("Cheery") do @aiConf['disposition'] = "cheery" end
          disposition.choice("Depressed") do @aiConf['disposition'] = "depressed" end
          disposition.choice("Extreme") do @aiConf['disposition'] = "extreme" end
          disposition.choice("Misanthropic (hatred of human-kind)") do @aiConf['disposition'] = "misanthropic" end
          disposition.confirm = "\nAre you sure? [yes/no]: "
          disposition.responses[:ask_on_error] = disposition
        end
        store_conf
      end
      
      def store_conf
        log_message("message", "Writing eveMotion file...")
        begin
          synchronize(:update) do
            File.open('config/settings/eveMotion.yaml', 'w') do |fh|
              YAML.dump(@aiConf, fh)
            end
          end
        rescue
          puts "#{$!}"
          log_message("error", "Error: #{$!}")
          abort("Exiting due to above error!")
        end
        log_message("message", "eveMotion file written!")
        say("Master file written!")
      end
      
      def delete_conf
        log_message("warn", "Deleting eveMotion.yaml...")
        begin
          if File.exist?('config/settings/eveMotion.yaml')
            File.delete('config/settings/eveMotion.yaml')
          else
            log_message("warn", "The eveMotion.yaml file does not exist")
          end
        rescue
          log_message("error", "There seems to have been an issue deleting eveMotion.yaml: #{$!}")
        end
      end
    end
  end
end