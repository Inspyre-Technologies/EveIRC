# frozen_string_literal: true

require_relative '../command'

module EveInstaller
  module Commands
    class Wizard < EveInstaller::Command
      def initialize(options)
        @options = options
      end
      
      def execute(input: $stdin, output: $stdout)
        # Command logic goes here ...
        output.puts "OK"
      end
    end
  end
end
