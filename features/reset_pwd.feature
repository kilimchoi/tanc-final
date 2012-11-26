Feature: Receiving Reset Email
   Given I am logged in as a member
   When I am on the reset_password page
   And I press "Reset Password"
   Then I should be on the reset_email_sent page

Feature: Not getting redirected to Reset Password page 
   Given I am not logged in as a member
   When I am on the reset_password page 
   I should be redirected to the signup page
   
Feature: Resetting Password after getting an email
   Given I am on the update_password page
   And I fill in "email" with "oksi@berkeley.edu"
   And I fill in "password" with "1234"
   And I fill in "password-confirm" with "1234"
   And I press "Update Password" 
   Then I should be on the reset_success page 
