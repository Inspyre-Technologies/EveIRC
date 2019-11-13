class Setup
  module Setup

    def self.runner(sudo)
      cmd_prefix = if sudo
                     'sudo '
                   else
                     ''
                   end
      cmd = "#{cmd_prefix} gem install tty-prompt"
      system(cmd)
    end

  end
end
