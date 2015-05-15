require 'cinch'
require_relative '../../lib/helpers/authentication'
require_relative '../../lib/helpers/logger'
require_relative '../../lib/helpers/file_handler'

module Cinch
  module Plugins
    class Update
      include Cinch::Plugin
      include Cinch::Helpers

      Plugin_Name = "Update"

      match /update$/i, method: :update

      def update(m)
        log_message("message", "Received 'update' command from #{m.user.nick}", Plugin_Name)
        if authentication(m)
          log_message("message", "Current version: #{$eve_version}", Plugin_Name)
          log_message("message", "Pulling latest code...", Plugin_Name)
          log_message("message", "Checking out 'master' branch...", Plugin_Name)
          system("cd #{$path_file['github_path'] } && git checkout master", Plugin_Name)
          log_message("message", "Pulling...", Plugin_Name)
          system("git pull origin/master")
          log_message("message", "Finished pulling code from Github!", Plugin_Name)
          github_path = $path_file['github_path']
          git_version = File.open("#{github_path}/VERSION", &:readline)
          log_message("message", "Github version: #{git_version}")
          if git_version.to_s < $eve_version.to_s
            m.reply "Update found!"
            m.reply "Current version: #{$eve_version}"
            m.reply "New version: #{git_version}"
            if m.reply(agree("Do you want to upgrade to #{$eve_version}?"))
              m.reply "Test successful"
            else
              m.reply "Test failed"
            end
          else
            m.reply "You are already up to date!"
          end
        else
          m.reply "You are not authorized to update me!"
        end
      end
    end
  end
end
