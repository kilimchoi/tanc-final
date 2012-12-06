Feature: Administrator control
  As an admin of the organization
  I want to be able to view/edit/export member info

Background:
  Given the following members exist:
    | status    | member_type  | email              | password | city | Zip   | first | last | admin | id |
    | confirmed | member       | foo@bar.com        | 1234     | SF   | 94704 | foo   | bar  | t     | 1  |
    | Pending   | mailing_list | hjvds@berkeley.edu | 1234     | Berkeley | 94705 | hj | vds | f     | 2  |

Scenario: Admins should see the admin panel
  Given I logged in as "foo@bar.com" with password "1234"
  And I am on profile page
  Then I should see "Manage Database"
  And I follow "Manage Database"
  Then I should be on the admin landing page

Scenario: Admins should be able to log out
  Given I logged in as "foo@bar.com" with password "1234"
  And I am on the admin landing page
  When I follow "LOGOUT"
  Then I should be on the member landing page

Scenario: Admins should be able to export member data
  Given I logged in as "foo@bar.com" with password "1234"
  And I am on the admin landing page
  When I am on the database dump page

Scenario: Admins should be able to edit member profile
  Given I logged in as "foo@bar.com" with password "1234"
  And I am on the admin landing page
  When I follow "Detail"
  Then I should be on the show page with id "2"
  When I follow "Edit"
  Then I should be on the edit page with id "2"
  And I should see "You are now editing"
  When I fill in "first" with "Aldi"
  And I fill in "last" with "Zhupani"
  And I fill in "telephone" with "8787878"
  And I fill in "address1" with "210 Alvarado Road"
  And I fill in "address2" with "iuegdu"
  And I fill in "city" with "berkeley"
  And I fill in "state" with "CA"
  And I fill in "zip" with "89678"
  And I fill in "telephone" with "231313213"
  And I fill in "year_of_birth" with "1989"
  And I fill in "country_of_birth" with "Albania"
  And I select "0" from "number_of_children"
  And I select "Student" from "occupation"
  And I choose "gender_male"
  And I press "Continue"
  Then I should be on the show page with id "2"
