ENV['RACK_ENV'] = 'test'

require_relative '../../overlord'
require 'rack/test'
require 'rspec'

require_relative 'sinatra_helpers'

DEFAULT_ACODE = "1234"
DEFAULT_DCODE = "0000"

Given(/^the bomb is not booted$/) do
  @browser = get_browser
  reset_bomb(@browser)
end

When(/^I boot the bomb with activation code (\d+)$/) do |acode|
  boot_bomb(@browser, acode)
end

Then(/^The bomb will activate with code (\d+)$/) do |acode|
  activate_bomb(@browser, acode)
end

When(/^I boot the bomb with no activation code$/) do
  boot_bomb(@browser)
end

Given(/^the bomb has been booted with activation code (\d+)$/) do |acode|
  @browser = get_browser
  reset_bomb(@browser)
  boot_bomb(@browser, acode)
end

When(/^I activate the bomb with code (\d+)$/) do |acode|
  # this wording implies activation may not succeed
  post_data(@browser, "/api/activate?activation_code=#{acode}")
end

Then(/^the bomb will be activated$/) do
  check_state(@browser, 'active')
end

Then(/^the bomb will not be activated$/) do
  check_state(@browser, 'booted')
end

Given(/^the bomb has been activated with code (\d+)$/) do |acode|
  @browser = get_browser
  reset_bomb(@browser)
  boot_bomb(@browser, acode)
  activate_bomb(@browser, acode)
end

Then(/^the activation status will not change$/) do
  check_state(@browser, 'active')
end
