class EveInstall
  module Gems

    def check
      begin
        require 'tty-prompt'
      rescue LoadError
        install_gems
      end
    end

    def install
      return if $ran == 'yes'

      gemfile(true) do
        source 'https://rubygems.org'

        gem 'tty-prompt'
      end

      $ran = 'yes'

    end

  end
end