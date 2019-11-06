class EveInstaller
  class DepMan
    module Gems
      require_relative '../../../../eve_installer'

      path    = File.dirname(__FILE__)
      @deps   = File.readlines("#{path}/gems.deps")

      def self.do_check
        $gems_needed = Array.new
        @deps.each do |gem|
          puts "Checking for #{gem}"
          begin
            require gem
          rescue LoadError
            puts "Could not find #{gem}"
            gem = gem.gsub(/\n/,"")
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
          true
        else
          false
        end
      end

      def self.sudo_install(targets)
        targets = targets.join(' ')
        puts 'Preforming sudo gem install of ' + targets
        puts 'You will probably be asked for your password.'
        puts system 'sudo gem install ' + targets
        $dep_man_count = $dep_man_count + 1
      end

      def self.install(targets)
        puts system 'gem install ' + targets
        $dep_man_count = $dep_man_count + 1
      end
    end
  end
end
