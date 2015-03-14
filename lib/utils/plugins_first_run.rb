require_relative '../helpers/logger'

module Cinch
  module Plugins
    class PluginsFirstRun
      include Cinch::Plugin
      
      def initialize(*args)
        super
        @compileHash = {} unless @compileHash
        if agree("We are now going to enter configuration for your plugins. Are you ready? [yes/no] ")
          avail_plugins = JSON.parse(open('config/settings/avail_plugins.json').read)
          plugin_names  = avail_plugins['plugins'].each do |plugin, settings, value|
            if agree("Do you want to enable the #{plugin} plugin? [yes/no] ")
              needKey  = settings['keyRequired']
              constant = settings['constant']
              mapping  = settings['file']
              apiURL   = settings['apiURL']
              
              if needKey == true
                puts "You need to add a key for the #{plugin} plugin. You can register for an API key here: #{apiURL}"
                puts "Please enter your API key for the #{plugin} plugin."
                
                key = gets
                key = key.chomp
                
                puts "Thank you! Your API key for the #{plugin} plugin is recorded as #{key}"
              end
              
              filePath = "require_relative '../../plugins/#{mapping}'"
              
              compileOptions = @compileHash[plugin] ||= {}
              compileOptions['constant'] = constant
              compileOptions['mapping']  = filePath
            else
              say("#{plugin} not enabled.")
            end
          end
          update_plugins(@compileHash)
        else
          say("Okay! Starting with no plugins!")
          sleep config[:delay] || 2
        end
      end
      
      def core_plugins
        log_message("message", "Preparing to write core plugins...")
        log_message("message", "Writing core plugins to plugins file...")
        open('config/settings/plugins.rb', 'a') {|f|
          f.puts "require_relative '../../plugins/core/admin_handler'"
          f.puts "require_relative '../../plugins/core/bot_info'"
        }
        log_message("message", "Core plugins written to plugins file! Proceeding...")
        log_message("message", "Writing core plugins to constants file...")
        open('config/settings/constants.rb', 'a') {|f|
          f.puts "Cinch::Plugins::AdminHandler"
          f.puts "Cinch::Plugins::BotInfo"
        }
        log_message("message", "Core plugins written to constants file! Core plugins written.")
        log_message("message", "Registering plugins with the bot...")
        load 'config/settings/plugins.rb'
        @bot.plugins.register_plugin(Cinch::Plugins::AdminHandler)
        @bot.plugins.register_plugin(Cinch::Plugins::BotInfo)
        log_message("message", "Core plugins registered with bot!")
      end
    
      def update_plugins(data)
        log_message("message", "Creating plugins file...")
        File.new('config/settings/plugins.rb', 'w')
        log_message("message", "Created!")
        
        data = data.each do |plugin, settings|
          constant = settings['constant']
          mapping  = settings['mapping']
          
          log_message("message", "Preparing #{plugin}...")
          
          log_message("message", "Writing #{plugin} to plugins file...")
          open('config/settings/plugins.rb', 'a') { |f| f.puts "#{mapping}" }
          
          log_message("message", "Writing #{plugin} to constant file...")
          open('config/settings/constants.rb', 'a') { |f| f.puts "#{constant}" }
          
          log_message("message", "Registering #{plugin}...")
          load 'config/settings/plugins.rb'
          
          begin
            constant = Cinch::Plugins.const_get(constant)
            @bot.plugins.register_plugin(constant)
          rescue NameError
            log_message("error", "Could not load plugin because no matching class was found! || #{$!} ||")
            abort("Please contact the creator of the bot for further information.")
          rescue
            log_message("error", "There was an issue loading the plugin! || #{$!} ||")
            abort("Please try running configuration without loading this plugin")
          end
        end
        update_main
        core_plugins
        puts "Fantastic! Starting bot..."
        sleep config[:delay] || 2
      end
      
      def create_restore
        log_message("message", "Creating bot restore point...")
        FileUtils.cp_r('', 'lib/restore/', :verbose => true)
        log_message("message", "Bot restore point created!")
      end
      
      def update_main
        data = "require_relative 'config/settings/plugins.rb'"
        new_main = File.new("Eve1.rb", 'w')
        new_main.puts(data)
        
        old_main = File.open("Eve.rb", 'r+')
        old_main.each_line { |line| new_main.puts line }
        
        new_main.close()
        old_main.close()
        
        begin
          File.rename("Eve.rb", "lib/restore/Eve.rb")
          log_message("message", "Restore point created, can be found in '~/lib/restore/Eve.rb'")
        rescue
          File.delete("Eve1.rb")
          log_message("error", "There seems to have been an issue creating the restore point: #{$!}")
          abort("There was an error creating restore point. Aborting.")
        end
        
        File.rename("Eve1.rb", "Eve.rb")
      end
    end
  end
end
