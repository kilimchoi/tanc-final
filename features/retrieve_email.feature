Feature: 
   As a member
   I want to be able to retrieve my email in case I forgot it

Background:
    Given the following members exist:
    | status    | member_type  | email                    | password | city          | Zip   |
    | Pending   | mailing list | hjvds@berkeley.edu       | 1234     | Berkeley      | 94705 |
    | confirmed | member       | azhupani390@berkeley.edu | 34578    | San Francisco | 75201 |

Feature: Receiving Retrieve Email email
   Given I am logged in with email "azhupani390@berkeley.edu"
   When I am on the retrieve_email page
   And I press "Retrieve Email"
   Then I should be on the retrieve_email_sent page

Feature: Not getting redirected to Retrieve Email page 
   Given I am logged in with email "hjvds@berkeley.edu"
   When I am on the retrieve_email page 
   I should be redirected to the signup page
   
