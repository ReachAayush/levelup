Feature: Site Navigation
In order to see all the items I want
As an online shopper
I want to be able to navigate the site from my cart

Scenario: Cart to Item
  Given I have a widget in my cart
  When I click the name of the widget
  Then I should be redirected to the widget page

Scenario: Item to Cart
  Given I am on the widget page
  When I click the cart icon
  Then I should be redirected to the cart page

