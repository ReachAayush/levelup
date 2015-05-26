# run `ruby overlord.rb` to run a webserver for this app

require 'sinatra'

enable :sessions

get '/' do
  "Time to build an app around here. Start time: " + start_time
end

get '/init' do
  "Looks like you're ready to boot up a bomb, post to /boot to set it up"
end

post '/boot' do
  set_codes(params[:activation_code], params[:deactivation_code])
  "The bomb has been booted! Activation code is #{activation_code}!\
  Deactivation code is #{deactiavtion_code}!"
end



# we can shove stuff into the session cookie YAY!
def start_time
  session[:start_time] ||= (Time.now).to_s
end

def set_codes(act, deact)
  session[:activation_code] = act || 1234
  session[:deactivation_code] = deact || 0000
end

def activation_code
  session[:activation_code]
end
  
def deactivation_code
  session[:deactivation_code]
end
