Feature: Login or Sign up for members and non-members
	As a non-member or member, 
	I want to sign up my email 
	so that I can receive updates 

Scenario: New member sign up
    Given I am on the login page
    And I follow "New User Sign up here!"
    Then I should be on the sign up page
    When I fill in "email" with "my_email@berkeley.edu"
    And I press "Continue"
    Then I should be on the thanks page


Scenario: New member can't sign up
    Given I am on the login page
    And I follow "New User Sign up here!"
    Then I should be on the sign up page
    And I press "Continue"
    Then I should be on the sign up page


