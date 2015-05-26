Feature: Bomb can be activated
  In order to activate my bomb from long range
  As a mad scientist
  I want to active the bomb from a web application

  Scenario: Configuration
    Given the bomb is not booted
    When I boot the bomb with activation code 5678
    Then The bomb will activate with code 5678

  Scenario: Default Code
    Given the bomb is not booted
    When I boot the bomb with no activation code
    Then The bomb will activate with code 1234
    
  Scenario: Activating Bomb
    Given the bomb has been booted with activation code 1234
    When I enter code 1234 into the bomb
    Then the bomb will be activated

  Scenario: Wrong Code
    Given the bomb has been booted with activation code 1234
    When I enter code 5678 into the bomb
    Then the bomb will not be activated

  Scenario: Already Active
    Given the bomb has been activated with code 1234
    When I enter code 1234 into the bomb
    Then the activation status will not change
