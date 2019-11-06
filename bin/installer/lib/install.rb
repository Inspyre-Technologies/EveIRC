class EveInstaller
  class Install

    def initialize
      create_prompt
      puts 'I have begun'
    end

    def create_prompt
      require 'tty_prompt'
      @prompt = TTY::Prompt.new
    end

  end
end
