class EveInstaller
  module Gems

    def self.check
      if answer.match(@yes_inputs)
        if Gem.ruby.include?('/usr/bin/ruby') && !Process.uid.zero?
          ask_root
        else
          Setup.runner(false)
        end
      else
        p 'received no'
      end
    end

  end
end