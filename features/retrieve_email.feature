Feature: Receiving Retrieve Email email
   Given I am logged in as a member
   When I am on the retrieve_email page
   And I press "Retrieve Email"
   Then I should be on the retrieve_email_sent page

Feature: Not getting redirected to Retrieve Email page 
   Given I am not logged in as a member
   When I am on the retrieve_email page 
   I should be redirected to the signup page
   
