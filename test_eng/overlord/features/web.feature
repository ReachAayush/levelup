Feature: Web Site
  In order to use cURL less
  As a front-endy person
  I want to interact with the bomb in the browser

  @javascript
  Scenario: Big Red Button
    Given We have not accessed the site this session
    When I access the site
    Then The button should say BOOT
