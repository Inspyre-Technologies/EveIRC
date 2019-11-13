class EveInstaller
  module Gems

    def self.check
      begin
        require 'tty-prompt'
      rescue LoadError
        install
      end
    end

    def self

    def self.install
      return if $ran == 'yes'

      gemfile(true) do
        source 'https://rubygems.org'

        gem 'tty-prompt'
      end

      $ran = 'yes'

    end

  end
end