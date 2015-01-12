require './pastie'

run Rack::URLMap.new('/' => Sinatra::Application)