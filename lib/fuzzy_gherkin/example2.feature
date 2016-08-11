Feature: Stock coffee

  Background:
    Given we are out of coffee
    And the staff is getting upset

  Scenario: Restock the coffee supply
    And I restock the coffee
    Then the staff is happy

  Scenario: Catastrophic Failure
    And we are out of coffee
    Then there is a revolt
