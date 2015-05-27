ENV['RACK_ENV'] = 'test'

require_relative '../../overlord'
require 'rack/test'
require 'rspec'
require 'json'

def get_browser
  Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
end

def post_data(browser, url)
  browser.post url
  expect(browser.last_response).to be_ok
  data = JSON.parse(browser.last_response.body)  
end

def get_data(browser, url)
  browser.get url
  expect(browser.last_response).to be_ok
  data = JSON.parse(browser.last_response.body)  
end

def reset_bomb(browser)
  data = post_data(browser, '/api/reset')
  expect(data['success']).to be_truthy
  expect(data['state']).to eq('unset')
end

def gen_boot_url(acode, dcode)
  url = '/api/boot'
  if acode && dcode
    url += "?activation_code=#{acode}&deactivation_code=#{dcode}"
  elsif acode && !dcode
    url += "?activation_code=#{acode}"
  elsif dcode && !acode
    url += "?deactivation_code=#{dcode}"
  end
  url
end

def boot_bomb(browser, acode=nil, dcode=nil)
  url = gen_boot_url(acode, dcode)
  data = post_data(browser, url)
  expect(data['success']).to be_truthy
  expect(data['state']).to eq('booted')
end

def activate_bomb(browser, acode)
  data = post_data(browser, "/api/activate?activation_code=#{acode}")
  expect(data['success']).to be_truthy
  expect(data['state']).to eq('active')
end

def deactivate_bomb(browser, dcode)
  data = try_deactivate_bomb(browser, dcode)
  expect(data['success']).to be_truthy
  expect(data['state']).to eq('defused')
end

def try_deactivate_bomb(browser, dcode)
  data = post_data(browser, "/api/deactivate?deactivation_code=#{dcode}")
end
 
def check_state(browser, state)
  data = get_data(browser, '/api/state')
  expect(data['state']).to eq(state)
end
