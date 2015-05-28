Feature: Cart Management
In order to be able to shop online effciently
As an online shopper
I want to be able to manage the items in my cart

Scenario: Add Something to Cart
  Given I do not have a widget in my cart
  When I click the button to add a widget to my cart
  Then There should be 1 widget in my cart

Scenario: Add Duplicate
  Given I have a widget in my cart
  When I click the button to add a widget to my cart
  Then There should be 2 widgets in my cart
  And I should see a notification about a duplicate item

Scenario: Change Item Quantity
  Given I have a widget in my cart
  When I click the change quantity button
  And I set the quantity to 3
  Then There should be 3 widgets in my cart

Scenario: Remove Item
  Given I have a widget in my cart
  When I click the button to remove a widget
  Then There should not be a widget in my cart
  And I should see a notification about removing an item

