ENV['RACK_ENV'] = 'test'

require_relative '../../overlord'
require 'rack/test'
require 'rspec'
require 'json'

def get_data(url)
  browser = Rack::Test::Session.new(Rack::MockSession.new(Sinatra::Application))
  browser.post url
  expect(browser.last_response).to be_ok
  data = JSON.parse(browser.last_response.body)  
end

def reset_bomb
  data = get_data('/api/reset')
  expect(data['success']).to be_truthy
  expect(data['state']).to eq('unset')
end

def boot_bomb(acode)
  data = get_data("/api/boot?activation_code=#{acode}")
  expect(data['success']).to be_truthy
  expect(data['state']).to eq('booted')
end

def activate_bomb(acode)
  data = get_data("/api/activate?activation_code=#{acode}")
  expect(data['success']).to be_truthy
  expect(data['state']).to eq('active')
end

def check_state(state)
  data = get_data('/api/state/')
  expect(data['state']).to eq(state)
end

Given(/^the bomb is not booted$/) do
  reset_bomb
end

When(/^I boot the bomb with activation code (\d+)$/) do |acode|
  boot_bomb(acode)
end

Then(/^The bomb will activate with code (\d+)$/) do |acode|
  activate_bomb(acode)
end

When(/^I boot the bomb with no activation code$/) do
  data = get_data('/api/boot')
  expect(data['success']).to be_truthy
  expect(data['state']).to eq('booted')  
end

Given(/^the bomb has been booted with activation code (\d+)$/) do |acode|
  reset_bomb
  boot_bomb(acode)
end

When(/^I activate the bomb with code (\d+)$/) do |acode|
  activate_bomb(acode)
end

Then(/^the bomb will be activated$/) do
  check_state('active')
end

Then(/^the bomb will not be activated$/) do
  check_state('booted')
end

Given(/^the bomb has been activated with code (\d+)$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^the activation status will not change$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
