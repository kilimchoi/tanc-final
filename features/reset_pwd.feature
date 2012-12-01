Feature: Resetting your password
   As a member, 
   I want to be able to reset my password in case I forgot it
Background:
    Given the following members exist:
    | status    | member_type  | email                    | password | city          | Zip   |
    | Pending   | mailing list | hjvds@berkeley.edu       | 1234     | Berkeley      | 94705 |
    | confirmed | member       | azhupani390@berkeley.edu | 34578    | San Francisco | 75201 |

Scenario: Receiving Reset Email
   Given I am logged in with email "azhupani390@berkeley.edu"
   When I am on the reset_password page
   And I press "Reset Password"
   Then I should be on the reset_email_sent page

Scenario: Not getting redirected to Reset Password page 
   Given I am logged in with email "hjvds@berkeley.edu"
   When I am on the reset password page 
   Then I should be redirected to the signup page
   
Scenario: Resetting Password after getting an email
   Given I am on the update password page
   And I fill in "email" with "oksi@berkeley.edu"
   And I fill in "password" with "1234"
   And I fill in "password-confirm" with "1234"
   And I press "Update Password" 
   Then I should be on the reset_success page 
