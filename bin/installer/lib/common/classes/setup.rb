
# @since 1.0
#
# A higher namespace in which to cluster all this madness in
module EveIRCInstaller
  class Application

    # @author Taylor-Jayde Blackstone <t.blackstone@inspyre.tech>
    # @since 1.0
    #
    # The Setup class for the eveIRC bot
    #
    # This class will set-up the end-user's environment with the
    # gems necessary to run the actual installer
    class Setup
      require_relative 'lib/setup/setup.rb'

      # The main instruction function for this class and
      # therefore the entire installer
      def self.main
        raise BundlerError::InstallError.new message = 'A different message'
      rescue BundlerError::InstallError => e
        puts e.msg

        # Setup::BundleMan.load_deps
        # greet
      end

      # This method may be refactored and folded into the
      # function that starts the actual eveIRC Installer
      # program
      def self.greet
        begin
          $prompt = TTY::Prompt.new
          $prompt.say 'Welcome to the eveIRC Installer'
        rescue LoadError
          puts 'welp'
        end
      end

      main
    end
  end
end

