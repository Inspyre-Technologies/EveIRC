module EveIRCInstaller
  class MainApplication
    module Helpers
      class Parser
        require 'optparse'

        $options = {}

        def self.parse(*)
          OptionParser.new do |opts|
            opts.banner = "Usage: example.rb [options]"

            opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
              $options[:verbose] = v
            end
          end.parse!
        end

      end
    end
  end
end
