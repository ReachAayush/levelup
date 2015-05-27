Feature: Bomb can be deactivated
  In order to prevent mass destructiong
  As a Jack Bauer
  I want to deactivate the bomb from a web application

  Scenario: Configuration
    Given the bomb is not booted
    When I boot the bomb with deactivation code 1234
    And I activate the bomb
    Then the bomb will deactivate with code 1234

  Scenario: Default Code
    Given the bomb is not booted
    When I boot the bomb with no deactivation code
    And I activate the bomb
    Then the bomb will deactivate with code 0000

  Scenario: Deactivating Bomb
    Given the bomb is activated with deactivation code 1234
    When I deactivate the bomb with code 1234
    Then the bomb will be defused

  Scenario: Exploding Bomb
    Given the bomb is activated with deactivation code 1234
    When I try to deactivate the bomb with code 0000 3 times
    Then the bomb will be exploded

  Scenario: Not Exploding Bomb
    Given the bomb is activated with deactivation code 1234
    When I try to deactivate the bomb with code 0000 2 times
    Then the bomb will be active
