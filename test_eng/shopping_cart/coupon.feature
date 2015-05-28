Feature: Coupons!!!!!
In order to save loads of dough
As an online shopper
I want to be able to apply coupons to my purchases in my shopping cart

Scenario: Adding Valid Coupon
  Given I have a widget in my cart
  When I click the button to add a coupon
  And I enter the coupon code for 50% off widgets
  Then The widget should cost 50% less
  And I should see a coupon icon next to the widget

Scenario: Removing a Coupon
  Given I have a widget in my cart
  And I have applied a coupon for 50% off widgets
  When I click the button to remove the coupon
  And I should not see a coupon icon next to the widget
  And The widget should cost full price

Scenario: Adding an Invalid Coupon
  Given I have a widget in my cart
  When I click the button to add a coupon
  And I enter the coupon code for 30% off wockets
  Then The widget should be full price
  And I should not see a coupon icon next to the widget
