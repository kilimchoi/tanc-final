Feature: Managing Database
  As an admin
  In order to keep the database updated
  I want to edit the database entries  

Background:  
  Given the following member exists:
     |email                | password   | first_name  | last_name | Edited |
     | kl_choi@berkeley.edu| secret_pwd | Ki          | Choi      | T      |



Scenario: Add a new member
     Given I am logged in as an admin
     Then I should be on the database page
     When I press "add" 
     Then I should be on the add page
     Given I fill up all_member_info
     And I press "save"
     Then I should be on the confirmation page

Scenario: Edit an existing member
     Given I am logged in as an admin
     Then I should be on the database page
     When I press "Edit"  
     Then I should be on the edit page
     And I fill in "first_name" with "Tenzin"
     And I press "save" 
     Then I should see the following content: 
     |email               | password   | first_name | last_name | Edited |
     |kl_choi@berkeley.edu| secret_pwd | Tenzin     | choi      | T      |

Scenario: Delete a member
     Given I am logged in as an admin
     Then I should be on the database page
     When I press "Delete"  
     Then I should be on the delete confirmation page

Scenario: Send email through the mailing list 
     Given I am logged in as an admin
     Then I should be on the database page
     Then I press "email"
     Then I should be on the mass email page
     When I fill in "subject" with "loren ipsum" 
     And I fill in "content" with "blah"
     And I press "send" 
     Then I should be on the email_sent page


