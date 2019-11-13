class Setup
  
  # A library of functions that allow us to check for gems
  # that are required for the auto-installer, and run a 
  # bundler install for them if there's a load error
  module BundleMan

    # Checks for the indicated dependencies and invokes
    # BundleMan#make if it experiences a LoadError 
    # exception
    def self.load_deps
      require 'tty-prompt'
    rescue LoadError
      make
    end

    # Runs a bundle install of the gems indicated if
    # BundleMan#load_deps experiences a LoadError exception
    def self.make
      return if $ran == 'yes'

      gemfile(true) do
        source 'https://rubygems.org'

        gem 'tty-prompt'
      end

      $ran = 'yes'

    end

  end
end