# @author Taylor-Jayde Blackstone <t.blackstone@inspyre.tech>
# @since 5.09
#
# The EveInstaller class for the eveIRC bot
class EveInstaller
  require 'optparse'
  require_relative 'lib/eve_install/helpers/helpers'
  require_relative 'lib/eve_setup'
  require_relative 'lib/dep_man'
  require_relative 'lib/eve_install/helpers/core'
  require_relative 'lib/install'

  attr_accessor :connection_check, :no_hint, :docs_base_url, :issue_url, :github_url

  @github_base      = 'https://github.com/Inspyre-Technologies/EveIRC/'
  @connection_check = true
  @no_hint          = false
  @docs_base_url    = "#{@github_base}wiki/eveIRC-Auto-Installer"
  @issue_url        = "#{github_base}issues/new?assignees=doubledave%2C+"\
                      'tayjaybabee&labels=installer%2C+Investigating&'\
                      'template=installer_issue.md&title=%5BINSTALLER%3A+Issue%5D'


  options = {}
  OptionParser.new do |opts|
    opts.banner = 'Usage: eve_install [options]'

    opts.on('-v', '--[no-]verbose', 'Run verbosely') do |v|
      options[:verbose] = v
    end

    opts.on('-N', '--no-conn-check', 'Do not run a connectivity check') do |noconn|
      options[:noconn] = noconn
      EveInstaller.connection_check = false

    end
  end.parse!

  p options
  p ARGV

  yes = [
    /y/i,
    /yes/i
  ]

  YES_PAT = Regexp.union(yes)


  # When the user has indicated a desire to exit the program
  # this function is called
  #
  # @param code String The exit-code provided by the caller
  def self.user_exit(code)
    p code
    Core.user_exit(code)
  end

  def self.report_error(error, exit_opts = nil )
    e = error
    puts e.msg
    puts e.hint
    case exit_opts
      when nil
        return
      when is_a?(Array)
        clean_exit(exit_opts)

    end
  end

  def err_exit(opts = [])
    if opts.include? 'give_doc'
      puts EveInstaller.docs_base_url
    end
    exit 1
  end

  def sigint_exit
    exit 1
  end


  def self.clean_exit(opts)
    case opts[0]
    when 'user'
      user_exit(opts[1])
    when 'prog_err'

      err_exit(opts)
    when 'sig_interrupt'
      sigint_exit
    else
      err_exit
    end
  end

  # Main function of the eveIRC installer program, the firing-
  # pin - if you will.
  def self.main
    system 'clear'
    puts 'Hello, welcome to the eveIRC installer!'
    begin
      EveInstaller::DepMan.new
    rescue DepMan::MissingDependenciesError::UserDeclineError => e
      puts e.msg
      puts e.hint unless @no_hint
      puts 'Exiting...'

    rescue DepMan::PermissionsError => e
      report_error(e, ['prog_error'])

    end
  end

  main
end