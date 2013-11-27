require 'yaml'

module Cinch::Plugins
  class Memo
    include Cinch::Plugin

    def initialize(*args)
      super
        if File.exist?('memos.yaml')
          @memos = YAML.load_file('memos.yaml')
        else
          @memos = {}
        end
      end

    listen_to :message

    match /memo (.+?) (.+)/

    def listen(m)
      if @memos.key?(m.user.nick) and @memos[m.user.nick].size > 0
        while @memos[m.user.nick].size > 0
          msg = @memos[m.user.nick].shift
          m.user.send msg
        end
          @memos.delete m.user.nick
          update_store
        end
      end

    def execute(m, nick, message)
      if nick == m.user.nick
        m.reply "You can't leave memos for yourself..."
      elsif nick == bot.nick
        m.reply "You can't leave memos for me..."
      elsif @memos.key?(nick)
        msg = make_msg(m.user.nick, m.channel, message, Time.now)
        @memos[nick] << msg
        m.reply "Added memo for #{nick}"
        update_store
      else
        @memos[nick] ||= []
        msg = make_msg(m.user.nick, m.channel, message, Time.now)
        @memos[nick] << msg
        m.reply "Added memo for #{nick}"
        update_store
      end
    end

    def update_store
      synchronize(:update) do
      File.open('memos.yaml', 'w') do |fh|
      YAML.dump(@memos, fh)
    end
  end
end

    def make_msg(nick, channel, text, time)
      t = time.strftime("%Y-%m-%d")
      "Memo from #{nick} sent at #{t}: #{text}"
    end
  end
end