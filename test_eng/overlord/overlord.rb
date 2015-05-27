# run `ruby overlord.rb` to run a webserver for this app

require 'sinatra'
require 'json'
require_relative 'bomb'

enable :sessions
# I might need to set the display on exceptions
set :show_exceptions, :after_handler

get '/' do
  redirect '/index.htm'
end

post '/api/reset' do
  bomb = Bomb.new
  res = {
    success: true,
    state: bomb.state,
    msg: "Bomb reset",
  }
  write_bomb(bomb)
  JSON.generate(res)
end

post '/api/boot' do
  bomb = session_bomb
  puts params
  bomb.boot(params[:activation_code], params[:deactivation_code])
  res = {
    success: true,
    state: bomb.state,
    msg: "Bomb booted successfully",
  }
  write_bomb(bomb)
  JSON.generate(res)
end

post '/api/activate' do
  bomb = session_bomb
  bomb.activate(params[:activation_code])
  res = {
    success: true,
    state: bomb.state,
    msg: "Bomb activated",
  }
  write_bomb(bomb)
  JSON.generate(res)
end

post '/api/deactivate' do
  bomb = session_bomb
  bomb.deactivate(params[:deactivation_code])
  res = {
    success: true,
    state: bomb.state,
    msg: "Bomb defused (Counter Terrorists Win)",
  }
  write_bomb(bomb)
  JSON.generate(res)
end

get '/api/state' do
  bomb = session_bomb
  res = {
    success: true,
    state: bomb.state,
    msg: nil,
  }
  JSON.generate(res)
end

error BombError do
  status 200
  bomb = session_bomb
  res = {
    success: false,
    state: bomb.state,
    msg: env['sinatra.error'].message,
  }
  JSON.generate(res)
end

# we can shove stuff into the session cookie YAY!
def start_time
  session[:start_time] ||= (Time.now).to_s
end

def session_bomb
  session[:bomb] || Bomb.new
end

def write_bomb(b)
  session[:bomb] = b
end
