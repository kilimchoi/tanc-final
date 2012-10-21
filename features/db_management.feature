Feature: Managing Database
	As an admin
	In order to keep the database updated
	I want to edit the database entries  

Background: 
        Given I am logged in as an admin 
	Then I should be on tanc/db_manage


Scenario: Add a new member
	When I press "add" 
	Then I should be on the tanc/db_manage/add
	Given I fill up all_member_info
	And I press "save"
	Then I should be on the tanc/db_manage/add_confirmation
Background:
        Given the following member exists:
	   |email               | password   | first_name | last_name |
           |kl_choi@berkeley.edu| secret_pwd | Ki         | choi      | Edit | Delete|

Scenario: Edit an existing member
        When I press "Edit"  
        Then I should be on tanc/db_manage/1/edit
        And I fill in "first_name" with "Tenzin"
        And I press "save" 
 	Then I should see the following content: 
	  |email               | password   | first_name | last_name |
          |kl_choi@berkeley.edu| secret_pwd | Tenzin     | choi      | Edit |

Scenario: Delete a member
        When I press "Delete"  
        Then I should be on tanc/db_manage/delete_cofirmation

Scenario: Send email through the mailing list 
        Given I am on the tanc/db_manage
        Then I press "email"
        Then I should be on the tanc/db_manage/mass_email
	When I fill in "subject" with "loren ipsum" 
	And I fill in "content" with "blah"
        And I press "send" 
	Then I should be on tanc/db_manage/email_sent


           
