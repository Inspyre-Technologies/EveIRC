# frozen_string_literal: true

class EveInstaller

  # @author Taylor-Jayde Blackstone <t.blackstone@inspyre.tech>
  # @since 1.0
  #
  # A little module to help manage any uninstalled dependencies
  # (for right now only w/ gems)
  class DepMan
    require_relative '../eve_installer/helpers/environment'
    include EveInstaller::Helpers
    include EveInstaller::Helpers::Environment
    require_relative 'lib/gems/gems'
    require_relative 'lib/errors'
    include EveInstaller::DepMan::Gems

    @prefix = ''

    # This simply acts as a boolean abstract for
    # EveInstaller::Helpers::Gems.do_check for now
    #
    # @return Boolean true: Gem dependency requirements are met | false: they are not
    # @todo Add checks for package dependencies in this algorithm as well


    def initialize
      raise InfiniteInstallError if $dep_man_count >= 1
      puts 'Starting pre-install checks...'
      begin
        puts 'Starting network check...'
        Environment::Network.check
      end
      if check_gems
        puts 'Pre-Install checks finished!'
        puts 'Nothing to install!'
        return
      end

      raise MissingDependenciesError::UserDeclineError unless Gems.install_missing?

      get_gems
    end


    def get_gems
      if Environment.need_sudo?
        puts 'System-wide Ruby install detected!'
        begin
          User.elevate
          Gems.sudo_install($gems_needed)
        rescue PermissionsError => e
          puts 'Unable to install gem dependencies!'
          puts 'MESSAGE: ' + e.msg
          puts 'ADVICE: ' + e.hint
        end
      else
        Gems.install($gems_needed)

      end
      raise InfiniteInstallError unless require 'tty-prompt'
    end

    def check_gems
      Gems.do_check ? true : false
    end

    # Advise the user that their environment lacks the needed gems.
    # Further assist the user by offering to install the needed gems for
    # them - if the user pleases. On some system configurations (i.e. a user has
    # ruby installed via the system-wide package manager instead of RVM or
    # something similar)
    #
    # @return Boolean true: user indicated desire to continue | false: user declined
    def self.do_install?
      puts 'I have detected that one or more gems are needed for this install script to run'
      puts 'Without these gems you can not use this auto-install script for eveIRC!'
      puts 'Do you wish to install the needed gem(s)? [y/N] '
      answer = gets.chomp
      answer.match(User::YES_PAT) ? true : false
    end
  end

end