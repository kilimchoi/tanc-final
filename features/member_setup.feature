Feature: Setting up member's profile 
   As a member, 
   I want to set up my profile page

Background:
    Given the following members exist:
    | status  | member_type  | email              | password | city | Zip |
    | Pending | mailing list | hjvds@berkeley.edu | 1234     | Berkeley | 94705 |
    | confirmed | member     | azhupani390@berkeley.edu | 34578 | San Francisco | 75201 |

Scenario: Setting up the profile page for the first time as a member 
   Given I logged in as "hjvds@berkeley.edu" with password "1234"
   And I am on the account setup page
   And I fill in "password" with "1234"
   And I choose "membership_member" 
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

Scenario: Setting up the profile page for the first time as a non-member 
   Given I logged in as "hjvds@berkeley.edu" with password "1234"
   And I am on the account setup page
   And I fill in "password" with "1234"
   And I choose "membership_non-member" 
   And I press "Continue" 
   Then I should be on the next account setup non-member page
   And I fill in "first-name" with "tenzin"
   And I fill in "last-name" with "zhupani"
   And I fill in "telephone" with "231321323213213213"
   And I press "Submit" 
   Then I should be on profile page
   

