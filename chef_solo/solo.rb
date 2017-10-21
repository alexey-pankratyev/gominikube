# Set chef homedir
chef_home_dir = File.dirname(__FILE__)

# Set path to config
file_cache_path  '/tmp/chef_solo/cache'
cookbook_path File.join(chef_home_dir, 'chef_cookbooks')
log_location STDOUT
