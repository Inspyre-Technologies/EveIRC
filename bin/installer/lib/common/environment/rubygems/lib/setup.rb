module EveIRCInstaller
  class RubyGems
    module Setup

      def flag_system
        Tempfile.new('dep', '../tmp')
      end
      
      def check
        gems = %w[tty-prompt tty-config]
        gems.each do |gem|
          require gem
        rescue LoadError

          RubyGems.need_installed << gem
        end
      end
      
    end
  end
end