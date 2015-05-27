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

Given(/^the bomb is not booted$/) do
  data = get_data('/api/reset')
  expect(data["success"]).to be_truthy
  expect(data["state"]).to eq("unset")
end

When(/^I boot the bomb with activation code (\d+)$/) do |acode|
  data = get_data("/api/boot?activation_code=#{acode}")
  expect(data["success"]).to be_truthy
  expect(data["state"]).to eq("booted")
end

Then(/^The bomb will activate with code (\d+)$/) do |acode|
  data = get_data("/api/activate?activation_code=#{acode}")
  expect(data["success"]).to be_truthy
  expect(data["state"]).to eq("active")
end

When(/^I boot the bomb with no activation code$/) do

end

Given(/^the bomb has been booted with activation code (\d+)$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I enter code (\d+) into the bomb$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^the bomb will be activated$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^the bomb will not be activated$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Given(/^the bomb has been activated with code (\d+)$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^the activation status will not change$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
