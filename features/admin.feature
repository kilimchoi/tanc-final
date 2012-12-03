Feature: Administrator control
  As an admin of the organization
  I want to be able to view/edit/export member info

Background:
  Given the following members exist:
    | status    | member_type  | email              | password | city | Zip   | first | last | admin |
    | confirmed | member       | foo@bar.com        | 1234     | SF   | 94704 | foo   | bar  | t     |
    | Pending   | mailing_list | hjvds@berkeley.edu | 1234     | Berkeley | 94705 | hj | vds | f     |

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
