Feature: A cowboy scenario is loaded into memory
    As a user
    I want to load information about cowboys and attacks
    So that I can calculate things about the fighters

    Scenario: instantiate class
        Given Nothing is loaded
        When I create a Fighters object
        Then There should be a collection of cowboys
        And There should be a collection of attacks
        And I should see the list of cowboys and attacks
        

