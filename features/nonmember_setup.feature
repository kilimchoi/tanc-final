Feature: Setting up nonmember's profile
   As a nonmember,
   I want to set up my profile page

Scenario: Setting up the profile page for nonmembers
   Given I am on the account setup page
   And I fill in "password" with "1234"
   And I choose "membership"
   And I press "Continue"
   Then I should be on the next account setup page
   And I fill in "first-name" with "Peter"
   And I fill in "last-name" with "Tsoi"
   And I choose "gender"
   And I fill in "age" with "20"
   And I fill in "address-line-1" with "405 soda"
   And I fill in "address-line-2" with "UC Berkeley"
   And I fill in "city" with "Berkeley"
   And I fill in "state" with "CA"
   And I fill in "Zip" with "94709"
   And I fill in "telephone" with "231321323213213213"
   And I press "Continue"
   Then I should be on the next account setup page
