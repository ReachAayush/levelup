Feature: Login/Logout
In order to track my purchases
As an online shopper
I want to be able to login to the site

Feature: Successful Login
  Given I have not logged in
  And My username and password are butts and test
  When I enter butts as the username
  And I enter test as the password
  Then I should be logged in

Feature: Failed Login
  Given I have not logged in
  And My username and password are butts and test
  When I enter wrong as the username
  And I enter data as the password
  Then I should not be logged in

Feature: Logout
  Given I am logged in
  When I click the logout button
  Then I should be logged out
  And I should see a notification about logging out

Feature: Persistent Cart
  Given I am logged in
  And I have a widget in my cart
  When I log out
  And I log back in
  Then there should be a widget in my cart
