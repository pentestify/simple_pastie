require './pastie'
require './helpers'
 
root_dir = File.dirname(__FILE__)
 
set :environment, :production
set :root,         root_dir
set :app_file,     File.join(root_dir, 'pastie.rb')
set :public_folder, root_dir + '/public'
set :logging,  true
set :run,  false

log = File.new("sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

run Sinatra::Application
