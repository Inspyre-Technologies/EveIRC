class EveInstaller
  class DepMan
    module Gems
      require_relative '../../../eve_install'

      path    = File.dirname(__FILE__)
      @deps   = File.readlines("#{path}/gems.deps")

      def self.check
        @deps.each do |gem|
          puts "Checking for #{gem}"
          begin
            require gem
          rescue LoadError
            puts "Could not find #{gem}"
            $gems_needed = Array.new
            $gems_needed << gem
          end
        end
        if $gems_needed.to_a.empty?
          return true
        else
          return false
        end
      end

      def self.install_missing?
        puts "I've detected that the following required gems are needed for automatic install: #{$gems_needed.join(', ')}"
        puts 'Should I attempt to install them? [y/N] '
        answer = gets.chomp
        if answer.match(YES_PAT)
          puts 'yay'
          true
        else
          puts 'nay'
          false
        end
      end

      def self.sudo_install(targets)
        targets = targets.join(' ')
        puts 'Preforming sudo gem install of ' + targets
        puts 'You will probably be asked for your password.'
        puts system 'sudo gem install ' + targets
      end

      def self.install(targets)
        puts system 'gem install ' + targets
      end

      def self.do_install(targets)
        targets = targets.join(' ')
        case $sudo
          when nil
            system 'gem install ' + targets
          when true
            sudo_install(targets)
          else
            raise InternalApplicationError
        end


      end
    end
  end
end
