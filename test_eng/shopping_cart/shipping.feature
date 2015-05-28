Feature: Shipping Estimates
In order to accurately guage how much shipping will cost
As an online shopper
I want to be able to get a shipping estimate based on my addess

Scenario: Shipping Estimate
  Given I am in the shopping cart
  When I click on the shipping estimate button
  And I enter my address
  Then I should see an estimate for how much it will cost to ship

Scenario: Repeat Requests
  Given I am in the shopping cart
  And I am logged in
  When I click on the shipping estimate button
  Then I should see my past addresses as options
