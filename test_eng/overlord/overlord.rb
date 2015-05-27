# run `ruby overlord.rb` to run a webserver for this app

require 'sinatra'
require 'json'
require_relative 'bomb'

enable :sessions
# I might need to set the display on exceptions
set :show_exceptions, :after_handler

configure do
  bomb = Bomb.new
end

get '/' do
  redirect '/index.htm'
end

post '/api/reset' do
  bomb = get_bomb
  bomb = Bomb.new
  res = {
    success: true,
    state: bomb.state,
    msg: "Bomb reset",
  }
  set_bomb(bomb)
  JSON.generate(res)
end

post '/api/boot' do
  bomb = get_bomb
  puts params
  bomb.boot(params[:activation_code], params[:deactivation_code])
  res = {
    success: true,
    state: bomb.state,
    msg: "Bomb booted successfully",
  }
  set_bomb(bomb)
  JSON.generate(res)
end

post '/api/activate' do
  bomb = get_bomb
  bomb.activate(params[:activation_code])
  res = {
    success: true,
    state: bomb.state,
    msg: "Bomb activated",
  }
  set_bomb(bomb)
  JSON.generate(res)
end

post '/api/deactivate' do
  bomb = get_bomb
  bomb.deactivate(params[:deactivation_code])
  res = {
    success: true,
    state: bomb.state,
    msg: "Bomb defused (Counter Terrorists Win)"
  }
  set_bomb(bomb)
  JSON.generate(res)
end

get '/api/state' do
  bomb = get_bomb
  res = {
    success: true,
    state: bomb.state,
    msg: nil,
  }
  JSON.generate(res)
end

error BombError do
  status 200
  bomb = get_bomb
  res = {
    success: false,
    state: bomb.state,
    msg: env['sinatra.error'].message
  }
  JSON.generate(res)
end

# we can shove stuff into the session cookie YAY!
def start_time
  session[:start_time] ||= (Time.now).to_s
end

def get_bomb
  session[:bomb] || Bomb.new
end

def set_bomb(b)
  session[:bomb] = b
end
