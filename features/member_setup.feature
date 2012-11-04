Feature: Setting up member's profile 
   As a member, 
   I want to set up my profile page

Background:
    Given the following members exist:
    | status  | member_type  | email              | password |
    | Pending | mailing list | hjvds@berkeley.edu | 1234     |

Scenario: Setting up the profile page for the first time
   Given I logged in as "hjvds@berkeley.edu" with password "1234"
   And I am on the account setup page
   And I fill in "password" with "1234"
   And I choose "membership" 
   And I press "Continue" 
   Then I should be on the next account setup page
   And I fill in "first-name" with "tenzin"
   And I fill in "last-name" with "zhupani"
   And I choose "gender" 
   And I fill in "age" with "55"
   And I fill in "address-line-1" with "405 soda"
   And I fill in "address-line-2" with "UC Berkeley"
   And I fill in "city" with "Berkeley"
   And I fill in "state" with "CA"
   And I fill in "Zip" with "94709"
   And I fill in "telephone" with "231321323213213213" 
   And I press "Continue" 
   Then I should be on profile page


