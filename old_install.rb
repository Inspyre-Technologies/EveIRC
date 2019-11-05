require 'yaml'
# The script is for easy install of the gems Eve requires

# Below we are going to initialize this install script,
# by first checking that the needed files exist and if
# they don't create them.

@storage = {}

def config_check
  puts "Checking if default config files exist..."
  if File.exist?('docs/userinfo.yaml')
    @storage = YAML.load_file('docs/userinfo.yaml')
  else
    @storage = {}
    puts "Creating user config file..."
    system("touch docs/userinfo.yaml")
    puts "User config file created! (userinfo.yaml)"
  end
  if File.exist?('docs/seen.yaml')
    puts "No need to write seen.yaml, already exists!"
  else
    puts "Seen.yaml not found, creating file..."
    system("touch docs/seen.yaml")
    puts "Seen.yaml created!"
  end
  if File.exist?('docs/memos.yaml')
    puts "No need to write memos.yaml, already exists!"
  else
    puts "Memoes.yaml not found, creating file..."
    system("touch docs/memos.yaml")
    puts "Memoes.yaml created!"
  end
end
