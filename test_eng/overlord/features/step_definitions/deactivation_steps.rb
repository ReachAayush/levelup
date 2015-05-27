ENV['RACK_ENV'] = 'test'

require_relative '../../overlord'
require 'rack/test'
require 'rspec'

require_relative 'sinatra_helpers'

DEFAULT_ACODE = "1234"
DEFAULT_DCODE = "0000"

When(/^I boot the bomb with deactivation code (\d+)$/) do |dcode|
  boot_bomb(@browser, nil, dcode)
end

# all tests in this section will use the default bomb activation code
When(/^I activate the bomb$/) do
  activate_bomb(@browser, DEFAULT_ACODE)
end

Then(/^the bomb will deactivate with code (\d+)$/) do |dcode|
  deactivate_bomb(@browser, dcode)
end

When(/^I boot the bomb with no deactivation code$/) do
  boot_bomb(@browser)
end

Given(/^the bomb is activated with deactivation code (\d+)$/) do |dcode|
  @browser = get_browser
  reset_bomb(@browser)
  boot_bomb(@browser, nil, dcode)
  activate_bomb(@browser, DEFAULT_ACODE)
end

When(/^I deactivate the bomb with code (\d+)$/) do |dcode|
  deactivate_bomb(@browser, dcode)
end

Then(/^the bomb will be defused$/) do
  check_state(@browser, 'defused')
end

When(/^I try to deactivate the bomb with code (\d+) (\d+) times$/) do |dcode, n|
  n.to_i.times { try_deactivate_bomb(@browser, dcode) }
end

Then(/^the bomb will be exploded$/) do
  check_state(@browser, 'detonated')
end

Then(/^the bomb will be active$/) do
  check_state(@browser, 'active')
end
