require 'capybara/cucumber'

Capybara.app = Sinatra::Application

Given(/^We have not accessed the site this session$/) do
  Capybara.reset_sessions!
end

When(/^I access the site$/) do
  visit '/'
end

Then(/^The button should say BOOT$/) do
  expect(page).to have_content('BOOT')
end
