Feature: Serve coffee

  Background: 
    Given I want some coffee
    And the office has some in stock

  Scenario: Making espresso  
    When I press the espresso button
    And I press the brew coffee button
    Then espresso should be brewing

  Scenario: Making Coffee
    When I press the coffee button
    And I press the brew button
    Then coffee should be brewing
