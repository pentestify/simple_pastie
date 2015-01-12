require 'sinatra'
require 'redis'
require 'securerandom'

helpers do
  def sanitize(string="")
    string.gsub!("<","(.)(.)")
    string.gsub!(">","(.)(.)")
    # TODO - more filterin here pls!
  string
  end
end

configure do
  uri = URI.parse(ENV["REDISTOGO_URL"])
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

before do
  puts '[Params]'
  p params
end

get '/' do
 erb :paste
end

get '/show/:id' do
  paste_id = params[:id]
  begin
    @paste = $redis.get(paste_id)
  rescue
    @paste = "Unable to find"
  end
  erb :show
end

get '/show/:id/render' do
  paste_id = params[:id]
  begin
    @paste = $redis.get(paste_id) 
  rescue
    @paste = "Unable to find"
  end
  erb :render, :layout => :render_layout
end

post '/pasteit' do
  id = SecureRandom.uuid
  content = params["content"]

  $redis.set(id,sanitize(content))

  redirect "/show/#{id}"
end
