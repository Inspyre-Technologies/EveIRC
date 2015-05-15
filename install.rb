require 'highline/import'
require 'yaml'

def install(path)
  say("Creating #{path}...")
  system("mkdir #{path}")
  say("Successfully created #{path}")
  say("Moving Eve.rb...")
  system("cp Eve.rb #{path}/Eve.rb")
  say("Successfully moved Eve.rb")
  say("Unpacking Utilities...")
  say("Creating #{path}/lib/utils...")
  system("mkdir -p #{path}/lib/utils")
  say("Successfully created #{path}/lib/utils")
  system("cp -vr lib/utils/ #{path}/lib/")
  say("Successfully unpacked Utilities!")
  say("Unpacking Helpers...")
  say("Creating #{path}/lib/helpers...")
  system("mkdir -p #{path}/lib/helpers/dialog")
  say("Successfully created #{path}/lib/helpers/dialog")
  system("cp -vr lib/helpers/ #{path}/lib/")
  system("cp -vr lib/helpers/dialog #{path}/lib/helpers/")
  say("Successfully unpacked Helpers!")
  say("Unpacking core plugins...")
  say("Creating mkdir -p #{path}/plugins/core")
  system("mkdir -p #{path}/plugins/core")
  say("Successfully created #{path}/plugins/core")
  system("cp -vr plugins/core #{path}/plugins")
  say("Successfully unpacked core plugins!")
  say("Unpacking optional plugins...")
  system("cp -vr plugins/ #{path}/")
  say("Successfully unpacked optional plugins!")
  say("Unpacking config files...")
  say("Creating #{path}/config/settings...")
  system("mkdir -p #{path}/config/settings")
  say("Successfully created #{path}/config/settings")
  system("cp -vr config/settings #{path}/config")
  say("Successfully unpacked config files!")
  say("Copying other files...")
  system("cp -v LICENSE README.md VERSION #{path}")
  system("touch #{path}/config/settings/paths.yaml")
  say("Creating array for paths...")
  paths = {}
  say("Adding array to config...")
  paths['github_path'] = "#{Dir.pwd}"
  say("Saving #{path}/config/settings/paths.yaml")
  File.open("#{path}/config/settings/paths.yaml", 'w') {|f| f.write paths.to_yaml }
  say("Successfully saved paths!")
  say("Finished installing eve7")
  say("eve7 installed in #{path}")
  say("Navigate to the directory eve7 is in by: cd #{path}")
  say("Start eve7 by typing: ruby Eve.rb")
end

say "Welcome to the eve7 install wizard."
if agree("Are you ready to install eve7? [y/n]: ")
  install_path = ask("Please enter a file path you'd like eve7 installed to: [#{ENV['HOME']}/eve7]: ") {|path|
    path.default = "#{ENV['HOME']}/eve7"
    path.responses[:ask_on_error] = "The path you'd like eve7 installed to: #{path.default}"
    path.confirm = "Are you sure you want to install eve7 to <%= @answer %>? [y/n]: "
  }

  say "Preparing installation location..."
  if File.directory?("#{install_path}")
    say "#{install_path} already exists!"
    if agree("Overwrite? [y/n]: ")
      say "Deleting directory..."
      system("rm -rf #{install_path}")
      say "#{install_path} successfully deleted!"
      install(install_path)
    else
      say("Very well, aborting.")
      abort("Can not install in existing directory without overwriting....ABORTING")
    end
  else
    install(install_path)
  end
end

