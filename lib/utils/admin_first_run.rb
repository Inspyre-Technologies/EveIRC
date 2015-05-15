module Cinch
  module Plugins
    class AdminFirstRun
      include Cinch::Plugin

      def initialize(*args)
        super
        @masterFile = {}
        if agree("We are now going to run a first-run configuration, are you ready? [yes/no]: ")
          nickname = ask("First off, tell me what nickname you use on IRC: ") { |q|
            q.validate = /\A\w+\Z/
            q.responses[:not_valid] = "You can't have a blank IRC nickname!"
            q.responses[:ask_on_error] = "The nickname that you use on IRC: "
            q.confirm = "Are you sure you wish to set your nickname as <%= @answer %> [yes/no]: "
          }
          nickname = nickname.downcase.to_s
          @masterFile[nickname] ||= {}
          puts "Excellent! Thank you #{nickname}!"
        else
          abort("Thank you for using Eve. Come back when you're ready!")
        end
        authname = ask("\nPlease type your NickServ authname/account name: ") { |q|
          q.validate = /\A\w+\Z/
          q.responses[:not_valid] = "\nAuthname cannot be blank, please try again!"
          q.responses[:ask_on_error] = "\nType your NickServ authname/account name: "
          q.confirm = "\nAre you sure you wish to set your authname/account name to <%= @answer %> [yes/no]: "
        }

        @masterFile[nickname]['authname'] = authname.downcase
        @masterFile[nickname.to_s]['creation_date'] = Time.now
        @masterFile[nickname.to_s]['currently'] = false
        update_store
      end

      def update_store
        say("\nWriting master file...")
        begin
          synchronize(:update) do
            File.open('config/settings/masters.yaml', 'w') do |fh|
              YAML.dump(@masterFile, fh)
            end
          end
        rescue
          puts "#{$!}"
          abort("Error creating file: masters.yaml")
        end
        sleep config[:delay] || 3
        say("Master file written!")
      end

      def update_history
        begin
          synchronize(:update) do
            File.open('config/settings/logged.yaml', 'w') do |fh|
              YAML.dump(@masterHistory, fh)
            end
          end
        rescue
          puts "#{$!}"
          abort("Eror creating file: logged.yaml")
        end
      end
    end
  end
end
