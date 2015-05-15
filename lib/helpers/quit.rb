require_relative 'file_handler'
require_relative 'logger'

module Cinch
  module Helpers

    Helper_Name = "Helpers::Quit"

    def quit_safely
      log_out_users
      write_files
      log_message("message", "Successfully handled exiting!")
    end

    def log_out_users
      log_message("message", "Logging out all users before going offline...", Helper_Name)
      $admin_file.each do |admin, keys|
        log_message("message", "Logging out #{admin.capitalize}...")
        keys['currently'] = false
        log_message("message", "#{admin.capitalize} logged out!")
      end
    end

    def write_files
      log_message("message", "Writing all files to disk...", Helper_Name)
      file_writer("masters", "masters.yaml", $admin_file)
      file_writer("settings", "settings.yaml", $settings_file)
      file_writer("path", "paths.yaml", $path_file)
      if $user_file
        file_writer("user info", "user_info.yaml", $user_file)
      else
        log_message("warn", "Could not find user_info.yaml, skipped writing it to disk!", Helper_Name, "yes")
      end
    end
  end
end
