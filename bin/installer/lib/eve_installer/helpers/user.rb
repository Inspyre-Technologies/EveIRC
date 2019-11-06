class EveInstaller
  module Helpers
    # @author Taylor-Jayde Blackstone <t.blackstone@inspyre.tech>
    # @since 1.0
    #
    # A helper full of little subroutines to help
    # ascertain/change privileges
    module User

      def self.elevate
        return if is_sudo?
        
        prompt = "I've detected that your Ruby environment"\
                 " requires gems to be installed via a 'super-user'"\
                 " account yet; you didn't run me with elevated"\
                 ' access.'
        puts prompt
        puts
        puts 'Shall I attempt to invoke super-user access to install your gems? [y/N] '
        answer = gets.chomp
        raise EveInstaller::DepMan::PermissionsError unless answer.match(YES_PAT)
      end

      # Asks the user for permission to attempt to invoke the
      # 'gem install' command, prefixed with 'sudo'
      #
      # @return Boolean true - allowed to sudo | false - not allowed
      def self.can_sudo?
        puts "I've detected that your Ruby environment"\
             " requires gems to be installed via a 'super-user'"\
             " account yet; you didn't run me with elevated"\
             ' access.'
        puts
        puts 'Shall I attempt to invoke sudo? [y/N] '

        answer = gets.chomp

        $sudo = answer.match(YES_PAT) ? true : false

      end

      # Ascertains if run as sudo
      #
      # @return Boolean true - was run as sudo | false - was not
      def self.is_sudo?
        case Process.uid
          when 0
            true
          else
            false
        end
      end

    end

  end
end