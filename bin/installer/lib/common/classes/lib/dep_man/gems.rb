class DepMan

  # @author Taylor-Jayde Blackstone <t.blackstone@inspyre.tech>
  # @since 1.0
  #
  # BunMan (short for Bundler Manager) is the class DepMan initializes
  # to check for/install gem dependencies for the EveIRCInstaller
  #
  # @!attribute gems_needed
  #   @return [Array<String>] An array containing the gems needed to run the
  #     EveIRC Installer
  #
  # @!attribute gems_present
  #   @return [Array<String>] An array containing the gems - of those that
  #     EveIRC Installer needs to run as intended - found on the
  #     end-user's system with running {BunMan#assess}
  #
  # @!attribute gems_missing
  #   @return [Array<String>] After running {BunMan#assess} this attribute
  #     will be populated with an array of strings containing
  #     the names of needed gems that were not found when running
  #     {BunMan#assess}. The attribute will return an empty array
  #     if the user is not missing any gems eveIRC Installer is
  #     looking for or {BunMan#assess} hasn't been run yet.
  #
  #     This returned array will be used by {BunMan#inform_missing}
  #     to notify the user that due to missing dependencies they
  #     will need to authorize the installation of a few gems
  #     that eveIRC Installer is dependant upon
  class BunMan
    attr_accessor :gems_needed, :gems_present, :gems_missing

    def initialize

      @gems_needed = %w[tty-prompt tty-logger]

      assess

    end

    # A function to determine if provided string matches the names of
    # any gems installed on the end-user's environment.
    #
    # @return [Boolean] true; gem was found | false; gem was not present
    # @example Check for installed gem
    #   BunMan.installed?('tty-prompt') #=> false 
    # @param [String] gem The name of the gem to check
    def installed?(gem)
      system 'gem list --local $l' + gem
    end

    def inform_missing

    end

    # A function to determine which (if any) gems are going to
    # need to be installed by bundler
    #
    # @example Assess what gems are needed before install can begin
    #   BunMan.assess #=> Populates BunMan.gems_present and BunMan.gems_missing
    def assess
      needed = @gems_needed
      have = []
      missing = []
      needed.each do |gem|
        if installed?(gem)
          have << gem
          @gems_present = have.sort unless have.empty?
        else
          missing << gem
          @gems_missing = missing.sort unless missing.empty
        end
      end
    end

  end
end