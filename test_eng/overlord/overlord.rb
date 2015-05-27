# run `ruby overlord.rb` to run a webserver for this app

require 'sinatra'
require 'json'
require_relative 'bomb'

enable :sessions
set :raise_errors, false
set :show_exceptions, false

configure do
  @@bomb = Bomb.new
end

get '/' do
  "Time to build an app around here. Start time: " + start_time
end

post '/api/reset' do
  @@bomb = Bomb.new
  res = {
    success: true,
    state: @@bomb.state,
    msg: "Bomb reset",
  }
  JSON.generate(res)
end

post '/api/boot' do
  puts "Given: #{params[:activation_code]}, #{params[:deactivation_code]}"
  @@bomb.boot(params[:activation_code], params[:deactivation_code])
  res = {
    success: true,
    state: @@bomb.state,
    msg: "Bomb booted successfully",
  }
  JSON.generate(res)
end

post '/api/activate' do
  @@bomb.activate(params[:activation_code])
  res = {
    success: true,
    state: @@bomb.state,
    msg: "Bomb activated",
  }
  JSON.generate(res)
end

post '/api/deactivate' do
  @@bomb.deactivate(params[:deactivation_code])
  res = {
    success: true,
    state: @@bomb.state,
    msg: "Bomb defused (Counter Terrorists Win)"
  }
  JSON.generate(res)
end

get '/api/state' do
  res = {
    success: true,
    state: @@bomb.state,
    msg: nil,
  }
  JSON.generate(res)
end

error BombError do
  status 200
  res = {
    success: false,
    state: @@bomb.state,
    msg: env['sinatra.error'].message
  }
  JSON.generate(res)
end

# we can shove stuff into the session cookie YAY!
def start_time
  session[:start_time] ||= (Time.now).to_s
end
