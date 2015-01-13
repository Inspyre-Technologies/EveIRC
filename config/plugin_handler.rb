require 'json'

module Cinch
  module Plugins
    class PluginHandler
      include Cinch::Plugin
      
      def initialize(*args)
        super
        @compileHash = {} unless @compileHash
        if File.exist?('config/settings/plugins.rb')
          puts "Plugins already loaded, starting bot!"
          sleep config[:delay] || 3
        else
          puts "We are now going to enter configuration for your plugins. Are you ready? [y/n]"
          
          answer = gets
          answer = answer.chomp
          answer = answer.downcase
          
          if answer != "y"
            puts "OK! Starting with no plugins!"
            sleep config[:delay] || 3
          else
            availPlugins = JSON.parse(open('config/settings/avail_plugins.json').read)
            pluginNames  = availPlugins['plugins'].each do |plugin, settings, value|
              
              puts "Do you want to enable the #{plugin} plugin?"
              answer = gets
              answer = answer.chomp
              answer = answer.downcase
              
              if answer != "y"
                puts "Okay! Not enabling #{plugin} plugin!"
                sleep config[:delay] || 3
              else
                
                needKey  = settings['keyRequired']
                constant = settings['constant']
                mapping  = settings['file']
                
                if needKey == true
                  puts "You need to add a key for the #{plugin} plugin. You can register for an API key here: http://www.wunderground.com/weather/api/d/login.html"
                  puts "Please enter your API key for the #{plugin} plugin."
                  
                  key = gets
                  key = key.chomp
                  
                  puts "Thank you! Your API key for the #{plugin} plugin is recorded as #{key}"
                end
                
                filePath = "require_relative '../../plugins/#{mapping}'"
                
                compileOptions = @compileHash[plugin] ||= {}
                compileOptions['constant'] = constant
                compileOptions['mapping']  = filePath
                
              end
            end
            update_plugins(@compileHash)
          end
        end
      end

      def update_plugins(data)
        puts "Creating plugins file..."
        sleep config[:delay] || 3
        File.new('config/settings/plugins.rb', 'w')
        puts "Created!"
        
        data = data.each do |plugin, settings|
          constant = settings['constant']
          mapping  = settings['mapping']
          
          sleep config[:delay] || 3
          
          puts "Preparing #{plugin}..."
          sleep config[:delay] || 2
          
          puts "Writing #{plugin} to plugins file..."
          open('config/settings/plugins.rb', 'a') do |f|
            f.puts "#{mapping}"
          end
          sleep config[:delay] || 2
          
          puts "Writing #{plugin} to constant file..."
          open('config/settings/constants.rb', 'a') do |f|
            f.puts "#{constant}"
          end
          sleep config[:delay] || 2
          
          puts "Registering #{plugin}..."
          sleep config[:delay] || 2
          load 'config/settings/plugins.rb'
          begin
            constant = Cinch::Plugins.const_get(constant)
            @bot.plugins.register_plugin(constant)
          rescue NameError
            puts "Could not load plugin because no matching class was found!"
            abort("Please contact the creator of the bot for further information.")
          rescue
            puts "There was an issue loading the plugin!"
            abort("Please try running configuration without loading this plugin")
          end
        end
        update_main
        puts "Fantastic! Starting bot..."
        sleep config[:delay] || 2
        
      end
      
      def update_main
        data = "require_relative 'config/settings/plugins.rb'"
        newMain = File.new("Eve1.rb", 'w')
        newMain.puts(data)
        
        oldMain = File.open("Eve.rb", 'r+')
        oldMain.each_line { |line| newMain.puts line }
        
        newMain.close()
        oldMain.close()
        
        begin
          puts "Creating bot restore point..."
          File.rename("Eve.rb", "lib/restore/Eve.rb")
          sleep config[:delay] || 3
          puts "Restore point created, can be found in '~lib/restore/Eve.rb'"
          sleep config[:delay] || 3
        rescue
          File.delete("Eve1.rb")
          abort("There was an error creating restore point. Aborting.")
        end
        
        File.rename("Eve1.rb", "Eve.rb")
      end
    end
  end
end