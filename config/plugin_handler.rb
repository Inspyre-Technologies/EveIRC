require 'json'
require 'fileutils'
require 'tempfile'

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
              
              puts "Do you want to enable the #{plugin} plugin? [Default = n]"
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
                
              end
            end
            update_plugins(@compileHash)
          end
        end
      end

      def update_plugins(data)
        #create_restore
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
        puts "Starting Error Handler..."
        #errorRecovery(data)
        
      end
      
      def create_restore
        time = Time.now.getutc
        puts "[ #{time} ] -- Creating bot restore point..."
        FileUtils.cp_r('', 'lib/restore/', :verbose => true)
        puts "[ #{time} ] -- Bot restore point created!"
        sleep config[:delay] || 1
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
      
      def errorRecovery(data)
        pluginsFile   = 'config/settings/plugins.rb'
        constantsFile = 'config/settings/constants.rb'
        mainFile      = 'Eve.rb'
        
        puts "Looking for plugins file.,,"
        sleep config[:delay] || 2
        if File.exist?(pluginsFile)
          puts "Plugins file found. Deleting..."
          File.delete(pluginsFile)
          sleep config[:delay] || 2
          puts "Plugins file deleted..."
        else
          puts "No plugins file found. Resuming error recovery..."
          sleep config[:delay] || 2
        end
        
        puts "Looking for constants file..."
        sleep config[:delay] || 2
        if File.exist?(constantsFile)
          puts "Constants file found. Restoring..."
          data = data.each do |plugin, settings|
            puts "Removing constant for #{plugin}..."
            
            constant = settings['constant']
            
            tmp = Tempfile.new("temp")
            
            open(constantsFile, 'r').each { |l| tmp << l unless l.chomp == constant }
            tmp.close
            FileUtils.mv(tmp.path, constantsFile)
            
            puts "Constant for #{plugin} removed."
            sleep config[:delay] || 2
          end
          puts "Constants file restored!"
        else
          puts "No constants file found, this is a problem."
          puts "Recreating constants file..."
          sleep config[:delay] || 2
          File.new(constantsFile, 'w')
          File.open(constantsFile, 'w') { |f|
                                          f << "Cinch::Plugins::AdminHandler\n"
                                          f << "Cinch::Plugins::PluginHandler\n"
                                        }
          puts "Constants file recreated. It can be found in #{constantsFile}"
          sleep config[:delay] || 2
        end
        
        if File.exist?(mainFile)
          puts "Main file found. Restoring..."
          offendingLine = "require_relative 'config/settings/plugins.rb'"
          
          tmp = Tempfile.new("temp")
          
          open(mainFile, 'r').each { |l| tmp << l unless l.chomp == offendingLine }
          tmp.close
          FileUtils.mv(tmp.path, mainFile)
          
          sleep config[:delay] || 2
          puts "Main file restored!"
        else
          puts "Main file not found!"
          abort("Critical Error! No Eve.rb")
        end
        
        data = data.each do |plugin, settings|
          plugin_class = Cinch::Plugins.const_get(plugin)
          @bot.plugins.select {|p| p.class == plugin_class}.each do |p|
            @bot.plugins.unregister_plugin(p)
          end
        end
      end
    end
  end
end