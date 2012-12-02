Feature: Login or Sign up for members and non-members
    As a non-member or member, 
    I want to sign up my email 
    so that I can receive updates 

Scenario: New member sign up
    Given I am on the login page
    And I follow "New Member Sign Up"
    Then I should be on the sign up page
    When I fill in "email" with "my_email@berkeley.edu"
    And I press "Continue"
    Then I should be on the thanks page


Scenario: New member can't sign up
    Given I am on the login page
    And I follow "New Member Sign Up"
    Then I should be on the sign up page
    And I press "Continue"
    Then I should be on the sign up page

Scenario: Email must be unique during signup
    Given the following members exist:
        | status  | member_type  | email                 | password | city     | zip |
        | Pending | tibetan      | aldizhupani@gmail.com | 1234     | Berkeley | 94705 |
    And I am on the sign up page
    When I fill in "email" with "aldizhupani@gmail.com"
    And I press "Continue"
    Then I should see "Your account could not be created because you already signed up"

Scenario: Must confirm account with code in email
    Given the following members exist:
        | status  | member_type  | email                 | password | city     | zip |
        | Pending | tibetan      | aldizhupani@gmail.com | 1234     | Berkeley | 94705 |
    When I logged in as "aldizhupani@gmail.com" with password "12345"
    Then I should see "You already created an account with this email."

Scenario: New users can log in
    Given the following members exist:
      | status    | member_type  | email               | first | last | password | zip   |
      | confirmed | mailing_list | petertsoi@gmail.com | peter | tsoi | 1234     | 94709 |
    And I am on the login page
    When I fill in "email" with "petertsoi@gmail.com"
    And I fill in "password" with "1234"
    And I press "Login"
    Then I should be on profile page

Scenario: Invalid user can't login
    Given I am on the login page
    When I fill in "email" with "bozo@hotmail.com"
    And I fill in "password" with "HAHAHAHAHA"
    And I press "Login"
    Then I should see "Your login information is not correct."
