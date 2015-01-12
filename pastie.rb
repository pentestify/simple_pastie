require 'sinatra'
require 'redis'
require 'securerandom'

helpers do
  def sanitize(string)
    return "" unless string
    string.gsub!("</pre>","(.)(.)")
    # TODO - more filterin here pls!
    return string
  end
end

configure do
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
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
    redis.get(paste_id)
  rescue
    @paste = "Unable to find"
  end
  erb :show
end

get '/show/:id/render' do
  paste_id = params[:id]
  begin
    redis.get(paste_id) 
  rescue
    @paste = "Unable to find"
  end
  erb :render, :layout => :render_layout
end

post '/pasteit' do
  id = SecureRandom.uuid

  content = sanitize(params["content"])

  redis.set(id,content)

  redirect "/show/#{id}"
end
