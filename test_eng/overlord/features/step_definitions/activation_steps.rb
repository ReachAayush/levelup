ENV['RACK_ENV'] = 'test'

require_relative '../../overlord'
require 'rack/test'
require 'rspec'

require_relative 'sinatra_helpers'

DEFAULT_ACODE = "1234"
DEFAULT_DCODE = "0000"

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
  boot_bomb
end

Given(/^the bomb has been booted with activation code (\d+)$/) do |acode|
  reset_bomb
  boot_bomb(acode)
end

When(/^I activate the bomb with code (\d+)$/) do |acode|
  # this wording implies activation may not succeed
  post_data("/api/activate?activation_code=#{acode}")
end

Then(/^the bomb will be activated$/) do
  check_state('active')
end

Then(/^the bomb will not be activated$/) do
  check_state('booted')
end

Given(/^the bomb has been activated with code (\d+)$/) do |acode|
  reset_bomb
  boot_bomb(acode)
  activate_bomb(acode)
end

Then(/^the activation status will not change$/) do
  check_state('active')
end
