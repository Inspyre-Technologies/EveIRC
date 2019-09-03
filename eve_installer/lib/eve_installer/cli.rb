# frozen_string_literal: true

require 'thor'

module EveInstaller
  # Handle the application command line parsingilana0320
  # 
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    # Set up the verbose/DEBUG option
    class_option :debug,
                 type:    :boolean,
                 aliases: %w(--verbose -V -d),
                 default: false,
                 desc:    'Run in debug mode'
    
    desc 'version', 'eve_installer version'
    
    def version
      require_relative 'version'
      puts "v#{EveInstaller::VERSION}"
    end
    
    map %w(--version -v) => :version

    desc 'wizard', 'Starts the EveIRC install wizard to install the bot for you.'
    method_option :help, aliases: '-h', type: :boolean,
                  desc:           'Display usage information'

    def wizard(*)
      if options[:help]
        invoke :help, ['wizard']
      else
        require_relative 'commands/wizard'
        EveInstaller::Commands::Wizard.new(options).execute
      end
    end
  end
end
